const express = require('express'),
    router = express.Router();
const {
    modalidades_juergs,
    jogos_juergs,
    equipes_juergs,
} = require('../../models');

const { Op } = require("sequelize");

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

router.put('/nextFase', async (req, res) => {
    try {
        idEquipes = JSON.parse(req.body['idEquipes']); // Lista com id das equipes
        equipesGrupoNome = JSON.parse(req.body['equipesGrupoNome'])
        id = parseInt(req.body['id_modalidade']); // Id da modalidade
        const faseAtual = parseInt(req.body['fase_atual']); // fase atual da modalidade
        console.info('Fase atual 1: ' + faseAtual.toString());


        modalidade = (await modalidades_juergs.findByPk(id))['dataValues'];

        // Este if confere se a fase atual no app do usuario é a mesma no DB
        // Pode ser que outro ADM já tenha avançado a competição de fase.
        if (modalidade['fase'] == faseAtual) {
            // TODO:: Avançar a competição de fase e criar os respectivos jogos.
            switch (faseAtual) {
                case 0:
                    console.info('Fase atual 2: ' + faseAtual.toString());
                    await monta_tabela_grupos(idEquipes, equipesGrupoNome, id);
                    console.info('Fase atual 3: ' + faseAtual.toString());
                    await proxima_fase(id, faseAtual);
                    console.info('Fase atual 4: ' + faseAtual.toString());
                    break;
                case 1:
                    await monta_quartas(idEquipes, equipesGrupoNome, id);
                    await proxima_fase(id, faseAtual);
                    break;
                case 2:
                    await monta_semi(idEquipes, equipesGrupoNome, id);
                    await proxima_fase(id, faseAtual);
                    break;
                case 3:
                    await monta_final(idEquipes, equipesGrupoNome, id);
                    await proxima_fase(id, faseAtual);
                    break;
                case 4:
                    // TODO: Encerra a competição.
                    break;
                default:
                    res.json({
                        status: 'erro',
                        erro: 'A competição já encerrou',
                    })
                    break;
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
    try{
        idModalidade = JSON.parse(req.body['id_modalidade']);

        novoLocal = req.body['novo_local'];

        await modalidades_juergs.update({
            endereco: novoLocal,
        },{
            where: {
                id: idModalidade,
            }
        });

        res.json({
            status: 'sucesso'
        });
    }catch(e){
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



async function monta_tabela_grupos(idEquipes, nomeEquipes, idModalidade) {
    // Monta tabela Para:
    // 8 Grupos
    // 3 Times
    const faseAtual = 1
    await insere_jogos_juergs(nomeEquipes[0], nomeEquipes[1], idEquipes[0], idEquipes[1], 0, 0, false, idModalidade, faseAtual);
    await insere_jogos_juergs(nomeEquipes[2], nomeEquipes[0], idEquipes[2], idEquipes[0], 0, 0, false, idModalidade, faseAtual);
    await insere_jogos_juergs(nomeEquipes[1], nomeEquipes[2], idEquipes[1], idEquipes[2], 0, 0, false, idModalidade, faseAtual);

    await insere_jogos_juergs(nomeEquipes[3], nomeEquipes[4], idEquipes[3], idEquipes[4], 0, 0, false, idModalidade, faseAtual);
    await insere_jogos_juergs(nomeEquipes[5], nomeEquipes[3], idEquipes[5], idEquipes[3], 0, 0, false, idModalidade, faseAtual);
    await insere_jogos_juergs(nomeEquipes[4], nomeEquipes[5], idEquipes[4], idEquipes[5], 0, 0, false, idModalidade, faseAtual);

    await insere_jogos_juergs(nomeEquipes[6], nomeEquipes[7], idEquipes[6], idEquipes[7], 0, 0, false, idModalidade, faseAtual);
    await insere_jogos_juergs(nomeEquipes[8], nomeEquipes[6], idEquipes[8], idEquipes[6], 0, 0, false, idModalidade, faseAtual);
    await insere_jogos_juergs(nomeEquipes[7], nomeEquipes[8], idEquipes[7], idEquipes[8], 0, 0, false, idModalidade, faseAtual);

    await insere_jogos_juergs(nomeEquipes[9], nomeEquipes[10], idEquipes[9], idEquipes[10], 0, 0, false, idModalidade, faseAtual);
    await insere_jogos_juergs(nomeEquipes[11], nomeEquipes[9], idEquipes[11], idEquipes[9], 0, 0, false, idModalidade, faseAtual);
    await insere_jogos_juergs(nomeEquipes[10], nomeEquipes[11], idEquipes[10], idEquipes[11], 0, 0, false, idModalidade, faseAtual);

    await insere_jogos_juergs(nomeEquipes[12], nomeEquipes[13], idEquipes[12], idEquipes[13], 0, 0, false, idModalidade, faseAtual);
    await insere_jogos_juergs(nomeEquipes[14], nomeEquipes[12], idEquipes[14], idEquipes[12], 0, 0, false, idModalidade, faseAtual);
    await insere_jogos_juergs(nomeEquipes[13], nomeEquipes[14], idEquipes[13], idEquipes[14], 0, 0, false, idModalidade, faseAtual);

    await insere_jogos_juergs(nomeEquipes[15], nomeEquipes[16], idEquipes[15], idEquipes[16], 0, 0, false, idModalidade, faseAtual);
    await insere_jogos_juergs(nomeEquipes[17], nomeEquipes[15], idEquipes[17], idEquipes[15], 0, 0, false, idModalidade, faseAtual);
    await insere_jogos_juergs(nomeEquipes[16], nomeEquipes[17], idEquipes[16], idEquipes[17], 0, 0, false, idModalidade, faseAtual);

    await insere_jogos_juergs(nomeEquipes[18], nomeEquipes[19], idEquipes[18], idEquipes[19], 0, 0, false, idModalidade, faseAtual);
    await insere_jogos_juergs(nomeEquipes[20], nomeEquipes[18], idEquipes[20], idEquipes[18], 0, 0, false, idModalidade, faseAtual);
    await insere_jogos_juergs(nomeEquipes[19], nomeEquipes[20], idEquipes[19], idEquipes[20], 0, 0, false, idModalidade, faseAtual);

    await insere_jogos_juergs(nomeEquipes[21], nomeEquipes[22], idEquipes[21], idEquipes[22], 0, 0, false, idModalidade, faseAtual);
    await insere_jogos_juergs(nomeEquipes[23], nomeEquipes[21], idEquipes[23], idEquipes[21], 0, 0, false, idModalidade, faseAtual);
    await insere_jogos_juergs(nomeEquipes[22], nomeEquipes[23], idEquipes[22], idEquipes[23], 0, 0, false, idModalidade, faseAtual);

    await equipes_juergs.update({
        fase_equipe: faseAtual,
    }, {
        where: {
            id: idEquipes,
        }
    })
}

async function monta_quartas(idEquipes, nomeEquipes, idModalidade) {
    const faseAtual = 2
    await insere_jogos_juergs(nomeEquipes[0], nomeEquipes[1], idEquipes[0], idEquipes[1], 0, 0, false, idModalidade, faseAtual);
    await insere_jogos_juergs(nomeEquipes[2], nomeEquipes[3], idEquipes[2], idEquipes[3], 0, 0, false, idModalidade, faseAtual);
    await insere_jogos_juergs(nomeEquipes[4], nomeEquipes[5], idEquipes[4], idEquipes[5], 0, 0, false, idModalidade, faseAtual);
    await insere_jogos_juergs(nomeEquipes[6], nomeEquipes[7], idEquipes[6], idEquipes[7], 0, 0, false, idModalidade, faseAtual);

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
    await insere_jogos_juergs(nomeEquipes[0], nomeEquipes[1], idEquipes[0], idEquipes[1], 0, 0, false, idModalidade, faseAtual);
    await insere_jogos_juergs(nomeEquipes[2], nomeEquipes[3], idEquipes[2], idEquipes[3], 0, 0, false, idModalidade, faseAtual);

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
    await insere_jogos_juergs(nomeEquipes[0], nomeEquipes[1], idEquipes[0], idEquipes[1], 0, 0, false, idModalidade, faseAtual);
    await insere_jogos_juergs(nomeEquipes[2], nomeEquipes[3], idEquipes[2], idEquipes[3], 0, 0, false, idModalidade, faseAtual);

    await equipes_juergs.update({
        fase_equipe: faseAtual,
    }, {
        where: {
            id: idEquipes,
        }
    })
}

async function insere_jogos_juergs(nome_time_a, nome_time_b, id_time_a, id_time_b, resultado_a, resultado_b,
    encerrado, modalidade, etapa_jogo) {
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
        }
    ).then((result) => {
        return result;

    }).catch((Exception) => {
        console.log(Exception)
    });
}

async function proxima_fase(id_modalidade, faseAtual) {
    console.info('Fase atual: ' + faseAtual.toString());
    await modalidades_juergs.update({
        fase: faseAtual + 1,
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