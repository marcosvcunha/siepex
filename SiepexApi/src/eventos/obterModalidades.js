const express = require('express'),
    router = express.Router();
const {
    modalidades_juergs,
    jogos_juergs,
    equipes_juergs,
} = require('../../models');

const { Op } = require("sequelize");

const formatosCompeticao = {
    TIMES_32: 1,
    TIMES_24: 2,
    TIMES_16: 3,
    TIMES_12: 4 
};

const fasesCompeticao = {
    INSCRICAO: 0,
    GRUPOS: 1,
    QUARTAS: 2,
    SEMI: 3,
    FINAL: 4,
    ENCERRADO: 5,
};

const grupos = ['A1', 'A2', 'A3', 'B1', 'B2', 'B3', 'C1', 'C2', 'C3', 'D1', 'D2', 'D3', 'E1',
    'E2', 'E3', 'F1', 'F2', 'F3', 'G1', 'G2', 'G3', 'H1', 'H2', 'H3',];

router.put('/getAll', async (req, res) => {
    retorno = await listar();
    if (retorno) {
        res.json({
            status: 'ok',
            data: retorno.rows,
            count: retorno.count,
        })
    }
    else {
        res.json({
            status: 'nao_achou',
        })
    }
});

router.put('/listaTabela', async (req, res) => {
    retorno = await listarTabela(req.body['idModalidade'], req.body['etapa']);
    if (retorno) {
        res.json({
            status: 'sucesso',
            data: retorno.rows,
            count: retorno.count,
        })
    }
    else {
        res.json({
            status: 'erro',
        })
    }
});

router.put('/nextFase', async (req, res) => {
    try {
        idEquipes = JSON.parse(req.body['idEquipes']); // Lista com id das equipes
        equipesGrupoNome = JSON.parse(req.body['equipesGrupoNome'])
        id = parseInt(req.body['id_modalidade']); // Id da modalidade
        const faseAtual = parseInt(req.body['fase_atual']); // fase atual da modalidade

        modalidade = (await modalidades_juergs.findByPk(id))['dataValues'];

        // Este if confere se a fase atual no app do usuario é a mesma no DB
        // Pode ser que outro ADM já tenha avançado a competição de fase.
        if (modalidade['fase'] == faseAtual) {

            jogos_nao_encerrados = await jogos_juergs.findAndCountAll({
                where: {
                    modalidade: idModalidade,
                    etapa_jogo: faseAtual,
                    encerrado: false,
                }
            });

            // Confere se existem jogos nesta fase que não tiveram resultados lançados ainda
            // TODO: mudar para: jogos_nao_encerrados.count > 0
            if (jogos_nao_encerrados.count > 1000) {
                res.json({
                    status: 'erro',
                    erro: 'jogos nao encerrados'
                });
                return;
            } else {

                switch (faseAtual) {
                    case fasesCompeticao.INSCRICAO:
                        switch(modalidade.formatoCompeticao){
                            case formatosCompeticao.TIMES_32:
                                await monta_tabela_grupos_32(idEquipes, equipesGrupoNome, id);
                                break;
                            case formatosCompeticao.TIMES_24:
                                await monta_tabela_grupos_24(idEquipes, equipesGrupoNome, id);
                                break;
                            case formatosCompeticao.TIMES_16:
                                await monta_tabela_grupos_16(idEquipes, equipesGrupoNome, id);
                                break;
                            case formatosCompeticao.TIMES_12:
                                await monta_tabela_grupos_12(idEquipes, equipesGrupoNome, id);
                                break;
                        }
                        await proxima_fase(id, fasesCompeticao.GRUPOS);
                        break;
                    case fasesCompeticao.GRUPOS:
                        switch(modalidade.formatoCompeticao){
                            case formatosCompeticao.TIMES_32:
                                await monta_quartas(idEquipes, equipesGrupoNome, id);
                                await proxima_fase(id, fasesCompeticao.QUARTAS);
                                break;
                            case formatosCompeticao.TIMES_24:
                                await monta_quartas(idEquipes, equipesGrupoNome, id);
                                await proxima_fase(id, fasesCompeticao.QUARTAS);
                            break;
                            case formatosCompeticao.TIMES_16:
                                await monta_quartas(idEquipes, equipesGrupoNome, id);
                                await proxima_fase(id, fasesCompeticao.QUARTAS);
                                break;
                            case formatosCompeticao.TIMES_12:
                                await monta_semi(idEquipes, equipesGrupoNome, id);
                                await proxima_fase(id, fasesCompeticao.SEMI);
                                break;
                        }
                        break;
                    case fasesCompeticao.QUARTAS:
                        await monta_semi(idEquipes, equipesGrupoNome, id);
                        await proxima_fase(id, fasesCompeticao.SEMI);
                        break;
                    case fasesCompeticao.SEMI:
                        await monta_final(idEquipes, equipesGrupoNome, id);
                        await proxima_fase(id, fasesCompeticao.FINAL);
                        break;
                    case fasesCompeticao.FINAL:
                        // TODO: Encerra a competição.
                        break;
                    default:
                        res.json({
                            status: 'erro',
                            erro: 'A competição já encerrou',
                        })
                        break;
                }
            }

            res.json({
                status: 'sucesso',
            });
            return;

        } else {
            res.json({
                status: 'erro',
                erro: 'Modalidade nao esta mais nesta fase.'
            });
        }
    }
    catch (e) {
        console.error('Erro ao avançar de Fase: ' + e.toString())
        res.json({
            status: 'erro',
        });
        return;
    }
});

router.put('/lancaResultado', async (req, res) => {
    var modalidade = parseInt(req.body['idModalidade']);
    var etapa = req.body['etapa'];
    var resultados = req.body['resultados'].split(',');
    retorno = await atualizaTabelaSelect(modalidade, etapa);
    if (retorno) {

        switch (modalidade) {
            case 1:
            case 3:
                for (var i = 0; i != retorno.count; i++) {
                    atualizaTabelaUpdate(retorno.rows[i].id, resultados[i * 2], resultados[(i * 2) + 1]);
                }

                break;
        }
        res.json({
            status: 'ok',
            data: retorno.rows,
            count: retorno.count,
        })
    }
    else {
        res.json({
            status: 'nao_achou',
        })
    }
});


router.put('/atualizaJogos', async (req, res) => {
    try {
        jogos = JSON.parse(req.body['jogos']);
        for (i = 0; i < jogos.length; i++) {
            // Atualiza cada um dos jogos
            await jogos_juergs.update({
                resultado_a: jogos[i]['resultA'],
                resultado_b: jogos[i]['resultB'],
                encerrado: jogos[i]['encerrado'],
            }, {
                where: {
                    id: jogos[i]['id'],
                }
            }).catch((e) => {
                console.log('Erro ao atualizar valores: ' + String(e));
                res.json({
                    status: 'erro',
                });
                return;
            })
        }

        res.json({
            status: 'sucesso',
        });
        return;
    } catch (e) {
        console.log("Erro!!");
        res.json({
            status: 'erro',
        });
        return;
    }
});

router.put('/changeLocal', async (req, res) => {
    try {
        idModalidade = JSON.parse(req.body['id_modalidade']);

        novoLocal = req.body['novo_local'];

        await modalidades_juergs.update({
            endereco: novoLocal,
        }, {
            where: {
                id: idModalidade,
            }
        });

        res.json({
            status: 'sucesso'
        });
    } catch (e) {
        console.log(e);
        res.json({
            status: 'erro'
        });
    }
})

router.put('/pegarJogos/porTime', async (req, res) => {
    try {
        idEquipe = req.body['id_equipe'];

        jogos = await jogos_juergs.findAll({
            where: {
                [Op.or]: [
                    { id_time_a: idEquipe },
                    { id_time_b: idEquipe },
                ],
            },
            order: [
                ['id', 'desc'],
            ]
        });
        res.json({
            status: 'sucesso',
            data: jogos,
        });
    } catch (e) {
        res.json({
            status: 'erro'
        });
    }
});

router.put('/atualizaLocalJogo/:idJogo/:nomeLocal', async (req, res) => {
    try{
        nomeLocal = req.params.nomeLocal;
        idJogo = req.params.idJogo;
        result = await jogos_juergs.update({
            local_jogo: nomeLocal,
        }, {
            where: {
                id: idJogo,
            }
        })
        res.json({
            status: 'sucesso',
        })
    }catch(e){
        res.status(500).send({
            status: 'erro'
        })
    }
})

router.put('/pegarJogos/porEquipes', async (req, res) => {
    try {
        idEquipes = JSON.parse(req.body['id_equipes']);

        jogos = await jogos_juergs.findAll({
            where: {
                [Op.or]: [
                    { id_time_a: idEquipes },
                    { id_time_b: idEquipes },
                ],
            },
            order: [
                ['id', 'desc'],
            ]
        });
        res.json({
            status: 'sucesso',
            data: jogos,
        });
    } catch (e) {
        console.error('Erro ao obter Jogos por Equipes');
        res.json({
            status: 'erro'
        });
    }
});

router.get('/pegarJogos/porModalidade/:idModalidade', async (req, res) => {
    try {
        idModalidade = req.params.idModalidade
        jogos = await jogos_juergs.findAll({
            where: {
                modalidade: idModalidade
            },
            order: [
                ['id', 'asc'],
            ]
        });
        res.json({
            status: 'sucesso',
            data: jogos,
        });
    } catch (e) {
        console.error('Erro ao obter Jogos por modalidade');
        res.json({
            status: 'erro'
        });
    }

});

router.put('/alterarFormato', async (req, res) => {
    try{
        idModalidade = req.body['id_modalidade'];
        novoFormato = req.body['novo_formato'];

        modalidade = await modalidades_juergs.findAll({
            where: {
                id: idModalidade,
            }
        });

        faseAtual = modalidade[0].dataValues.fase;
        if(faseAtual == 0){
            await modalidades_juergs.update({
                formatoCompeticao: novoFormato,
            },{
                where: {
                    id: idModalidade,
                }
            });
            res.json({
                status: 'sucesso',
            });
            return;
        }else{
            res.json({
                status: 'erro',
                erro: 'nao esta na fase de inscricao'
            });
            return;
        }

    }catch(e){
        res.json({
            status: 'erro',
            erro: 'erro desconhecido'
        });
    }
});

// router.get('/pegaLocal/:idModalidade', async (req, res) => {
//     try{
//         result = await pegarLocalModalidade(req.params.idModalidade);
//         res.status(200).send(result) 
//     }catch(e){
//         res.status(500).send({
//             status: 'erro',
//         });
//     }
// })


async function monta_tabela_grupos_32(idEquipes, nomeEquipes, idModalidade) {
    // Monta tabela Para:
    // 8 Grupos
    // 4 Times

    // A x B
    // A x C
    // A x D
    // B x C
    // B x D
    // C x D

    local = await pegarLocalModalidade(idModalidade);

    const faseAtual = 1
    for(var i = 0; i < 8; i ++){
        await insere_jogos_juergs(nomeEquipes[4*i + 0], nomeEquipes[4*i + 1], idEquipes[4*i + 0], idEquipes[4*i + 1], 0, 0, false, idModalidade, faseAtual, local);
        await insere_jogos_juergs(nomeEquipes[4*i + 0], nomeEquipes[4*i + 2], idEquipes[4*i + 0], idEquipes[4*i + 2], 0, 0, false, idModalidade, faseAtual, local);
        await insere_jogos_juergs(nomeEquipes[4*i + 0], nomeEquipes[4*i + 3], idEquipes[4*i + 0], idEquipes[4*i + 3], 0, 0, false, idModalidade, faseAtual, local);
        await insere_jogos_juergs(nomeEquipes[4*i + 1], nomeEquipes[4*i + 2], idEquipes[4*i + 1], idEquipes[4*i + 2], 0, 0, false, idModalidade, faseAtual, local);
        await insere_jogos_juergs(nomeEquipes[4*i + 1], nomeEquipes[4*i + 3], idEquipes[4*i + 1], idEquipes[4*i + 3], 0, 0, false, idModalidade, faseAtual, local);
        await insere_jogos_juergs(nomeEquipes[4*i + 2], nomeEquipes[4*i + 3], idEquipes[4*i + 2], idEquipes[4*i + 3], 0, 0, false, idModalidade, faseAtual, local);
    }

    await equipes_juergs.update({
        fase_equipe: faseAtual,
    }, {
        where: {
            id: idEquipes,
        }
    })
}

async function monta_tabela_grupos_24(idEquipes, nomeEquipes, idModalidade) {
    // Monta tabela Para:
    // 8 Grupos
    // 3 Times
    const faseAtual = 1
    local = await pegarLocalModalidade(idModalidade);

    for(var i = 0; i < 8; i++){
        await insere_jogos_juergs(nomeEquipes[3*i + 0], nomeEquipes[3*i + 1], idEquipes[3*i + 0], idEquipes[3*i + 1], 0, 0, false, idModalidade, faseAtual, local);
        await insere_jogos_juergs(nomeEquipes[3*i + 2], nomeEquipes[3*i + 0], idEquipes[3*i + 2], idEquipes[3*i + 0], 0, 0, false, idModalidade, faseAtual, local);
        await insere_jogos_juergs(nomeEquipes[3*i + 1], nomeEquipes[3*i + 2], idEquipes[3*i + 1], idEquipes[3*i + 2], 0, 0, false, idModalidade, faseAtual, local);
    }
    await equipes_juergs.update({
        fase_equipe: faseAtual,
    }, {
        where: {
            id: idEquipes,
        }
    })
}

async function monta_tabela_grupos_16(idEquipes, nomeEquipes, idModalidade) {
    // Monta tabela Para:
    // 8 Grupos
    // 3 Times
    local = await pegarLocalModalidade(idModalidade);

    const faseAtual = 1
    for(var i = 0; i < 4; i++){
        await insere_jogos_juergs(nomeEquipes[4*i + 0], nomeEquipes[4*i + 1], idEquipes[4*i + 0], idEquipes[4*i + 1], 0, 0, false, idModalidade, faseAtual, local);
        await insere_jogos_juergs(nomeEquipes[4*i + 0], nomeEquipes[4*i + 2], idEquipes[4*i + 0], idEquipes[4*i + 2], 0, 0, false, idModalidade, faseAtual, local);
        await insere_jogos_juergs(nomeEquipes[4*i + 0], nomeEquipes[4*i + 3], idEquipes[4*i + 0], idEquipes[4*i + 3], 0, 0, false, idModalidade, faseAtual, local);
        await insere_jogos_juergs(nomeEquipes[4*i + 1], nomeEquipes[4*i + 2], idEquipes[4*i + 1], idEquipes[4*i + 2], 0, 0, false, idModalidade, faseAtual, local);
        await insere_jogos_juergs(nomeEquipes[4*i + 1], nomeEquipes[4*i + 3], idEquipes[4*i + 1], idEquipes[4*i + 3], 0, 0, false, idModalidade, faseAtual, local);
        await insere_jogos_juergs(nomeEquipes[4*i + 2], nomeEquipes[4*i + 3], idEquipes[4*i + 2], idEquipes[4*i + 3], 0, 0, false, idModalidade, faseAtual, local);
    }
    await equipes_juergs.update({
        fase_equipe: faseAtual,
    }, {
        where: {
            id: idEquipes,
        }
    })
}

async function monta_tabela_grupos_12(idEquipes, nomeEquipes, idModalidade) {
    // Monta tabela Para:
    // 8 Grupos
    // 3 Times
    const faseAtual = 1
    local = await pegarLocalModalidade(idModalidade);

    for(var i = 0; i < 4; i++){
        await insere_jogos_juergs(nomeEquipes[3*i + 0], nomeEquipes[3*i + 1], idEquipes[3*i + 0], idEquipes[3*i + 1], 0, 0, false, idModalidade, faseAtual, local);
        await insere_jogos_juergs(nomeEquipes[3*i + 2], nomeEquipes[3*i + 0], idEquipes[3*i + 2], idEquipes[3*i + 0], 0, 0, false, idModalidade, faseAtual, local);
        await insere_jogos_juergs(nomeEquipes[3*i + 1], nomeEquipes[3*i + 2], idEquipes[3*i + 1], idEquipes[3*i + 2], 0, 0, false, idModalidade, faseAtual, local);
    }
    await equipes_juergs.update({
        fase_equipe: faseAtual,
    }, {
        where: {
            id: idEquipes,
        }
    })
}




async function monta_quartas(idEquipes, nomeEquipes, idModalidade) {
    local = await pegarLocalModalidade(idModalidade);

    const faseAtual = 2
    await insere_jogos_juergs(nomeEquipes[0], nomeEquipes[1], idEquipes[0], idEquipes[1], 0, 0, false, idModalidade, faseAtual, local);
    await insere_jogos_juergs(nomeEquipes[2], nomeEquipes[3], idEquipes[2], idEquipes[3], 0, 0, false, idModalidade, faseAtual, local);
    await insere_jogos_juergs(nomeEquipes[4], nomeEquipes[5], idEquipes[4], idEquipes[5], 0, 0, false, idModalidade, faseAtual, local);
    await insere_jogos_juergs(nomeEquipes[6], nomeEquipes[7], idEquipes[6], idEquipes[7], 0, 0, false, idModalidade, faseAtual, local);

    await equipes_juergs.update({
        fase_equipe: faseAtual,
    }, {
        where: {
            id: idEquipes,
        }
    })

}

async function monta_semi(idEquipes, nomeEquipes, idModalidade) {
    const faseAtual = 3
    local = await pegarLocalModalidade(idModalidade);

    await insere_jogos_juergs(nomeEquipes[0], nomeEquipes[1], idEquipes[0], idEquipes[1], 0, 0, false, idModalidade, faseAtual, local);
    await insere_jogos_juergs(nomeEquipes[2], nomeEquipes[3], idEquipes[2], idEquipes[3], 0, 0, false, idModalidade, faseAtual, local);

    await equipes_juergs.update({
        fase_equipe: faseAtual,
    }, {
        where: {
            id: idEquipes,
        }
    })
}

async function monta_final(idEquipes, nomeEquipes, idModalidade) {
    const faseAtual = 4
    local = await pegarLocalModalidade(idModalidade);

    await insere_jogos_juergs(nomeEquipes[0], nomeEquipes[1], idEquipes[0], idEquipes[1], 0, 0, false, idModalidade, faseAtual, local);
    await insere_jogos_juergs(nomeEquipes[2], nomeEquipes[3], idEquipes[2], idEquipes[3], 0, 0, false, idModalidade, faseAtual, local);

    await equipes_juergs.update({
        fase_equipe: faseAtual,
    }, {
        where: {
            id: idEquipes,
        }
    })
}

async function insere_jogos_juergs(nome_time_a, nome_time_b, id_time_a, id_time_b, resultado_a, resultado_b,
    encerrado, modalidade, etapa_jogo, local) {
    await jogos_juergs.create(
        {
            time_a: nome_time_a,
            time_b: nome_time_b,
            id_time_a: (id_time_a == -2) ? 0 : id_time_a,
            id_time_b: (id_time_b == -2) ? 0 : id_time_b,
            resultado_a: resultado_a,
            resultado_b: resultado_b,
            encerrado: encerrado,
            modalidade: modalidade,
            etapa_jogo: etapa_jogo,
            local_jogo: local,
            nome_juiz: 'Não selecionado'
        }
    ).then((result) => {
        return result;

    }).catch((Exception) => {
        console.log(Exception)
    });
}

async function proxima_fase(id_modalidade, proxima_fase) {
    await modalidades_juergs.update({
        fase: proxima_fase,
    }, {
        where: {
            id: id_modalidade,
        }
    });
}

async function listar(estudanteCpf) {
    return new Promise(function (resolve, reject) {
        modalidades_juergs.findAndCountAll().then((result) => {
            resolve(result);
        })
    })
}

async function listarTabela(idModalidade, etapa) {
    console.log("ETAPA: ");
    console.log(etapa);
    return new Promise(function (resolve, reject) {
        jogos_juergs.findAndCountAll({
            where: {
                modalidade: idModalidade,
                etapa_jogo: etapa,
            }
        }).then((result) => {
            resolve(result);
        })
    })
}

async function atualizaTabelaSelect(idModalidade, etapa) {
    return new Promise(function (resolve, reject) {
        jogos_juergs.findAndCountAll({
            where: {
                modalidade: idModalidade,
                etapa_jogo: etapa,
            },
            order: [
                ['id', 'ASC'],
            ],
        }).then((jogosRetornados) => {
            resolve(jogosRetornados);
        })
    })
}

async function pegarLocalModalidade(idModalidade){
    return new Promise(function (resolve, reject){
        modalidades_juergs.findByPk(idModalidade).then((modalidade) => {
            resolve(modalidade.endereco);
        });
    });
}

function atualizaTabelaUpdate(id, resultado_a, resultado_b) {
    jogos_juergs.findByPk(id).then((jogo_atual) => {
        jogos_juergs.update({
            resultado_a: resultado_a,
            resultado_b: resultado_b,
        }, {
            where: {
                id: id,
            }
        })
    }).catch((err) => {
        console.log(err);
        res.json({
            status: 'erro',
        })
    }
    );
}

module.exports = router;