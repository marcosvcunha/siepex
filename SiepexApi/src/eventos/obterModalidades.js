const express = require('express'),
    router = express.Router();
const {
    modalidades_juergs,
    jogos_juergs,
    equipes_juergs,
} = require('../../models');

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
        equipesGrupoNome = req.body['equipesGrupoNome'].split(',');
        id = parseInt(req.body['id_modalidade']); // Id da modalidade
        faseAtual = parseInt(req.body['fase_atual']); // fase atual da modalidade

        modalidade = (await modalidades_juergs.findByPk(id))['dataValues'];

        // Este if confere se a fase atual no app do usuario é a mesma no DB
        // Pode ser que outro ADM já tenha avançado a competição de fase.
        if (modalidade['fase'] == faseAtual) {
            // TODO:: Avançar a competição de fase e criar os respectivos jogos.
            switch (faseAtual) {
                case 0:
                    await monta_tabela(idEquipes, equipesGrupoNome, id, faseAtual);
                    proxima_fase(id, faseAtual);
                    break;
                case 1:
                    await monta_quartas(idEquipes, equipesGrupoNome, id, faseAtual);
                    proxima_fase(id, faseAtual);
                    break;
                case 2:
                    monta_semi(idEquipes, equipesGrupoNome, id, faseAtual);
                    proxima_fase(id, faseAtual);
                    break;
                case 3:
                    monta_final(idEquipes, equipesGrupoNome, id, faseAtual);
                    proxima_fase(id, faseAtual);
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

async function monta_tabela(idEquipes, equipesGrupoNome, idModalidade, faseAtual) {

    switch (idModalidade) {
        case 1:
            for (var i = 0; i < 8; i++) {
                if (!equipesGrupoNome[(i * 3)]) {
                    equipesGrupoNome[(i * 3)] = 'Sem Equipe';
                    idEquipes[(i * 3)] = -2;
                }
                if (!equipesGrupoNome[(i * 3) + 1]) {
                    equipesGrupoNome[(i * 3) + 1] = 'Sem Equipe';
                    idEquipes[(i * 3) + 1] = -2;
                }
                if (!equipesGrupoNome[(i * 3) + 2]) {
                    equipesGrupoNome[(i * 3) + 2] = 'Sem Equipe';
                    idEquipes[(i * 3) + 2] = -2;
                }

                var nome_time_a = equipesGrupoNome[(i * 3)].replace('[', '').replace(']', '').trim();
                var nome_time_b = equipesGrupoNome[(i * 3) + 1].replace('[', '').replace(']', '').trim();
                var id_time_a = idEquipes[(i * 3)];
                var id_time_b = idEquipes[(i * 3) + 1];
                var resultado_a = 0;
                var resultado_b = 0;
                var encerrado = 0;
                var modalidade = idModalidade;
                var etapa_jogo = faseAtual;
                await insere_jogos_juergs(nome_time_a, nome_time_b, id_time_a, id_time_b, resultado_a, resultado_b,
                    encerrado, modalidade, etapa_jogo);
                nome_time_a = equipesGrupoNome[(i * 3)].replace('[', '').replace(']', '').trim();
                nome_time_b = equipesGrupoNome[(i * 3) + 2].replace('[', '').replace(']', '').trim();
                id_time_a = idEquipes[(i * 3)];
                id_time_b = idEquipes[(i * 3) + 2];
                await insere_jogos_juergs(nome_time_a, nome_time_b, id_time_a, id_time_b, resultado_a, resultado_b,
                    encerrado, modalidade, etapa_jogo);

                nome_time_a = equipesGrupoNome[(i * 3) + 1].replace('[', '').replace(']', '').trim();
                nome_time_b = equipesGrupoNome[(i * 3) + 2].replace('[', '').replace(']', '').trim();
                id_time_a = idEquipes[(i * 3) + 1];
                id_time_b = idEquipes[(i * 3) + 2];
                await insere_jogos_juergs(nome_time_a, nome_time_b, id_time_a, id_time_b, resultado_a, resultado_b,
                    encerrado, modalidade, etapa_jogo);
            }
            for (var i = 0; i != 24; i++) {
                if (!idEquipes[i]) {
                    return;
                }
                await atualiza_equipes_juergs(idEquipes, i, faseAtual);
            }
            break;
        case 2:
            for (var i = 0; i < 4; i++) {
                var nome_time_a = equipesGrupoNome[(i * 3)].replace('[', '').replace(']', '').trim();
                var nome_time_b = equipesGrupoNome[(i * 3) + 1].replace('[', '').replace(']', '').trim();
                var id_time_a = idEquipes[(i * 3)];
                var id_time_b = idEquipes[(i * 3) + 1];
                var resultado_a = 0;
                var resultado_b = 0;
                var encerrado = 0;
                var modalidade = idModalidade;
                var etapa_jogo = faseAtual;
                await insere_jogos_juergs(nome_time_a, nome_time_b, id_time_a, id_time_b, resultado_a, resultado_b,
                    encerrado, modalidade, etapa_jogo);
                nome_time_a = equipesGrupoNome[(i * 3)].replace('[', '').replace(']', '').trim();
                nome_time_b = equipesGrupoNome[(i * 3) + 2].replace('[', '').replace(']', '').trim();
                id_time_a = idEquipes[(i * 3)];
                id_time_b = idEquipes[(i * 3) + 2];
                await insere_jogos_juergs(nome_time_a, nome_time_b, id_time_a, id_time_b, resultado_a, resultado_b,
                    encerrado, modalidade, etapa_jogo);
                nome_time_a = equipesGrupoNome[(i * 3) + 1].replace('[', '').replace(']', '').trim();
                nome_time_b = equipesGrupoNome[(i * 3) + 2].replace('[', '').replace(']', '').trim();
                id_time_a = idEquipes[(i * 3) + 1];
                id_time_b = idEquipes[(i * 3) + 2];
                await insere_jogos_juergs(nome_time_a, nome_time_b, id_time_a, id_time_b, resultado_a, resultado_b,
                    encerrado, modalidade, etapa_jogo);
            }
            for (var i = 0; i != 12; i++) {
                await atualiza_equipes_juergs(idEquipes, i, faseAtual);
            }
            break;
        case 3:
            for (var i = 0; i < 4; i++) {
                var nome_time_a = equipesGrupoNome[(i * 4)].replace('[', '').replace(']', '').trim();
                var nome_time_b = equipesGrupoNome[(i * 4) + 1].replace('[', '').replace(']', '').trim();
                var id_time_a = idEquipes[(i * 4)];
                var id_time_b = idEquipes[(i * 4) + 1];
                var resultado_a = 0;
                var resultado_b = 0;
                var encerrado = 0;
                var modalidade = idModalidade;
                var etapa_jogo = faseAtual;
                await insere_jogos_juergs(nome_time_a, nome_time_b, id_time_a, id_time_b, resultado_a, resultado_b,
                    encerrado, modalidade, etapa_jogo);
                nome_time_a = equipesGrupoNome[(i * 4)].replace('[', '').replace(']', '').trim();
                nome_time_b = equipesGrupoNome[(i * 4) + 2].replace('[', '').replace(']', '').trim();
                id_time_a = idEquipes[(i * 4)];
                id_time_b = idEquipes[(i * 4) + 2];
                await insere_jogos_juergs(nome_time_a, nome_time_b, id_time_a, id_time_b, resultado_a, resultado_b,
                    encerrado, modalidade, etapa_jogo);
                nome_time_a = equipesGrupoNome[(i * 4)].replace('[', '').replace(']', '').trim();
                nome_time_b = equipesGrupoNome[(i * 4) + 3].replace('[', '').replace(']', '').trim();
                id_time_a = idEquipes[(i * 4)];
                id_time_b = idEquipes[(i * 4) + 3];
                await insere_jogos_juergs(nome_time_a, nome_time_b, id_time_a, id_time_b, resultado_a, resultado_b,
                    encerrado, modalidade, etapa_jogo);
                nome_time_a = equipesGrupoNome[(i * 4) + 1].replace('[', '').replace(']', '').trim();
                nome_time_b = equipesGrupoNome[(i * 4) + 2].replace('[', '').replace(']', '').trim();
                id_time_a = idEquipes[(i * 4) + 1];
                id_time_b = idEquipes[(i * 4) + 2];
                await insere_jogos_juergs(nome_time_a, nome_time_b, id_time_a, id_time_b, resultado_a, resultado_b,
                    encerrado, modalidade, etapa_jogo);
                nome_time_a = equipesGrupoNome[(i * 4) + 1].replace('[', '').replace(']', '').trim();
                nome_time_b = equipesGrupoNome[(i * 4) + 3].replace('[', '').replace(']', '').trim();
                id_time_a = idEquipes[(i * 4) + 1];
                id_time_b = idEquipes[(i * 4) + 3];
                await insere_jogos_juergs(nome_time_a, nome_time_b, id_time_a, id_time_b, resultado_a, resultado_b,
                    encerrado, modalidade, etapa_jogo);
                nome_time_a = equipesGrupoNome[(i * 4) + 2].replace('[', '').replace(']', '').trim();
                nome_time_b = equipesGrupoNome[(i * 4) + 3].replace('[', '').replace(']', '').trim();
                id_time_a = idEquipes[(i * 4) + 2];
                id_time_b = idEquipes[(i * 4) + 3];
                await insere_jogos_juergs(nome_time_a, nome_time_b, id_time_a, id_time_b, resultado_a, resultado_b,
                    encerrado, modalidade, etapa_jogo);
            }
            for (var i = 0; i != 16; i++) {
                await atualiza_equipes_juergs(idEquipes, i, faseAtual);
            }
            break;
        case 4:
        case 5:
            for (var i = 0; i < 2; i++) {
                var nome_time_a = equipesGrupoNome[(i * 4)].replace('[', '').replace(']', '').trim();
                var nome_time_b = equipesGrupoNome[(i * 4) + 1].replace('[', '').replace(']', '').trim();
                var id_time_a = idEquipes[(i * 4)];
                var id_time_b = idEquipes[(i * 4) + 1];
                var resultado_a = 0;
                var resultado_b = 0;
                var encerrado = 0;
                var modalidade = idModalidade;
                var etapa_jogo = faseAtual;
                await insere_jogos_juergs(nome_time_a, nome_time_b, id_time_a, id_time_b, resultado_a, resultado_b,
                    encerrado, modalidade, etapa_jogo);
                nome_time_a = equipesGrupoNome[(i * 4)].replace('[', '').replace(']', '').trim();
                nome_time_b = equipesGrupoNome[(i * 4) + 2].replace('[', '').replace(']', '').trim();
                id_time_a = idEquipes[(i * 4)];
                id_time_b = idEquipes[(i * 4) + 2];
                await insere_jogos_juergs(nome_time_a, nome_time_b, id_time_a, id_time_b, resultado_a, resultado_b,
                    encerrado, modalidade, etapa_jogo);
                nome_time_a = equipesGrupoNome[(i * 4)].replace('[', '').replace(']', '').trim();
                nome_time_b = equipesGrupoNome[(i * 4) + 3].replace('[', '').replace(']', '').trim();
                id_time_a = idEquipes[(i * 4)];
                id_time_b = idEquipes[(i * 4) + 3];
                await insere_jogos_juergs(nome_time_a, nome_time_b, id_time_a, id_time_b, resultado_a, resultado_b,
                    encerrado, modalidade, etapa_jogo);
                nome_time_a = equipesGrupoNome[(i * 4) + 1].replace('[', '').replace(']', '').trim();
                nome_time_b = equipesGrupoNome[(i * 4) + 2].replace('[', '').replace(']', '').trim();
                id_time_a = idEquipes[(i * 4) + 1];
                id_time_b = idEquipes[(i * 4) + 2];
                await insere_jogos_juergs(nome_time_a, nome_time_b, id_time_a, id_time_b, resultado_a, resultado_b,
                    encerrado, modalidade, etapa_jogo);
                nome_time_a = equipesGrupoNome[(i * 4) + 1].replace('[', '').replace(']', '').trim();
                nome_time_b = equipesGrupoNome[(i * 4) + 3].replace('[', '').replace(']', '').trim();
                id_time_a = idEquipes[(i * 4) + 1];
                id_time_b = idEquipes[(i * 4) + 3];
                await insere_jogos_juergs(nome_time_a, nome_time_b, id_time_a, id_time_b, resultado_a, resultado_b,
                    encerrado, modalidade, etapa_jogo);
                nome_time_a = equipesGrupoNome[(i * 4) + 2].replace('[', '').replace(']', '').trim();
                nome_time_b = equipesGrupoNome[(i * 4) + 3].replace('[', '').replace(']', '').trim();
                id_time_a = idEquipes[(i * 4) + 2];
                id_time_b = idEquipes[(i * 4) + 3];
                await insere_jogos_juergs(nome_time_a, nome_time_b, id_time_a, id_time_b, resultado_a, resultado_b,
                    encerrado, modalidade, etapa_jogo);
            }
            console.log('ID EQUIPES:');
            console.log(idEquipes);
            for (var i = 0; i != 8; i++) {
                await atualiza_equipes_juergs(idEquipes, i, faseAtual);
            }
            break;
    }

}

async function monta_quartas(idEquipes, equipesGrupoNome, idModalidade, faseAtual) {
    switch (idModalidade) {
        case 1:
            for (var i = 0; i < 4; i++) {
                if (!equipesGrupoNome[(i * 3)]) {
                    equipesGrupoNome[(i * 3)] = 'Sem Equipe';
                    idEquipes[(i * 3)] = -2;
                }
                if (!equipesGrupoNome[(i * 3) + 1]) {
                    equipesGrupoNome[(i * 3) + 1] = 'Sem Equipe';
                    idEquipes[(i * 3) + 1] = -2;
                }
                var nome_time_a = equipesGrupoNome[(i * 3)].replace('[', '').replace(']', '').trim();
                var nome_time_b = equipesGrupoNome[(i * 3) + 1].replace('[', '').replace(']', '').trim();
                var id_time_a = idEquipes[(i * 3)];
                var id_time_b = idEquipes[(i * 3) + 1];
                var resultado_a = 0;
                var resultado_b = 0;
                var encerrado = 0;
                var modalidade = idModalidade;
                var etapa_jogo = faseAtual;
                await insere_jogos_juergs(nome_time_a, nome_time_b, id_time_a, id_time_b, resultado_a, resultado_b,
                    encerrado, modalidade, etapa_jogo);
            }
            for (var i = 0; i < 8; i++) {
                if (!idEquipes[i]) {
                    return;
                }
                await atualiza_equipes_juergs(idEquipes, i, faseAtual);
            }
            break;
        case 2:
            break;
        case 3:
            break;
        case 4:
        case 5:
            break;
    }
}

async function monta_semi(idEquipes, equipesGrupoNome, idModalidade, faseAtual) {
    switch (idModalidade) {
        case 1:
            for (var i = 0; i < 2; i++) {
                if (!equipesGrupoNome[(i * 3)]) {
                    equipesGrupoNome[(i * 3)] = 'Sem Equipe';
                    idEquipes[(i * 3)] = -2;
                }
                if (!equipesGrupoNome[(i * 3) + 1]) {
                    equipesGrupoNome[(i * 3) + 1] = 'Sem Equipe';
                    idEquipes[(i * 3) + 1] = -2;
                }
                var nome_time_a = equipesGrupoNome[(i * 3)].replace('[', '').replace(']', '').trim();
                var nome_time_b = equipesGrupoNome[(i * 3) + 1].replace('[', '').replace(']', '').trim();
                var id_time_a = idEquipes[(i * 3)];
                var id_time_b = idEquipes[(i * 3) + 1];
                var resultado_a = 0;
                var resultado_b = 0;
                var encerrado = 0;
                var modalidade = idModalidade;
                var etapa_jogo = faseAtual;
                await insere_jogos_juergs(nome_time_a, nome_time_b, id_time_a, id_time_b, resultado_a, resultado_b,
                    encerrado, modalidade, etapa_jogo);
            }
            for (var i = 0; i < 4; i++) {
                if (!idEquipes[i]) {
                    return;
                }
                await atualiza_equipes_juergs(idEquipes, i, faseAtual);
            }
            break;
        //todo outros cases para outras modalidades
    }
}

async function monta_final(idEquipes, equipesGrupoNome, idModalidade, faseAtual) {
    switch (idModalidade) {
        case 1:
            console.log(equipesGrupoNome);
            if (!equipesGrupoNome[0]) {
                equipesGrupoNome[0] = 'Sem Equipe';
                idEquipes[0] = -2;
            }

            if (!equipesGrupoNome[1]) {
                equipesGrupoNome[1] = 'Sem Equipe';
                idEquipes[1] = -2;
            }

            var nome_time_a = equipesGrupoNome[0].replace('[', '').replace(']', '').trim();
            var nome_time_b = equipesGrupoNome[1].replace('[', '').replace(']', '').trim();
            var id_time_a = idEquipes[0];
            var id_time_b = idEquipes[1];
            var resultado_a = 0;
            var resultado_b = 0;
            var encerrado = 0;
            var modalidade = idModalidade;
            var etapa_jogo = faseAtual;
            await insere_jogos_juergs(nome_time_a, nome_time_b, id_time_a, id_time_b, resultado_a, resultado_b,
                encerrado, modalidade, etapa_jogo);

            var nome_time_a = equipesGrupoNome[2].replace('[', '').replace(']', '').trim();
            var nome_time_b = equipesGrupoNome[3].replace('[', '').replace(']', '').trim();
            var id_time_a = idEquipes[2];
            var id_time_b = idEquipes[3];
            var resultado_a = 0;
            var resultado_b = 0;
            var encerrado = 0;
            var modalidade = idModalidade;
            var etapa_jogo = faseAtual;
            await insere_jogos_juergs(nome_time_a, nome_time_b, id_time_a, id_time_b, resultado_a, resultado_b,
                encerrado, modalidade, etapa_jogo);


            for (var i = 0; i < 4; i++) {
                if (!idEquipes[i]) {
                }else
                    await atualiza_equipes_juergs(idEquipes, i, faseAtual);
            }
            break;
        //todo outros cases para outras modalidades
    }
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
            etapa_jogo: etapa_jogo + 1,
        }
    ).then((result) => {
        return result;

    }).catch((Exception) => {
        console.log(Exception)
    })
}

async function atualiza_equipes_juergs(id_time, i, faseAtual) {
    if (id_time[i] == -2) {
        return;
    }
    await equipes_juergs.findByPk(id_time[i]).then((equipe) => {
        equipes_juergs.update({
            grupo: grupos[i],
            fase_equipe: faseAtual + 1,
        }, {
            where: {
                id: id_time[i],
            }
        })
    }).catch((err) => {
        console.log(err);
    }
    );
}

function proxima_fase(id_modalidade, faseAtual) {
    modalidades_juergs.findByPk(id_modalidade).then((modalidade_atual) => {
        modalidades_juergs.update({
            fase: modalidade_atual.fase + 1,
        }, {
            where: {
                id: id_modalidade,
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