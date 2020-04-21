const express = require('express'),
    router = express.Router();
const {
    equipes_juergs,
    cadastro_juergs,
} = require('../../models');

router.put('/', async (req, res) => {
    // decide qual função usar com base no parametro passado em req
    if ('id_modalidade' in req.body) {
        idModalidade = parseInt(req.body['id_modalidade']);
        equipes = await pegarTodasEquipesPorModalidade(idModalidade);
        res.json({
            data: equipes.rows,
            count: equipes.count,
        })
    } else if ('user_cpf' in req.body) {
        equipes = await pegarTodasEquipesPorUsuario(req.body['user_cpf']);
        res.json({
            data: equipes.rows,
            count: equipes.count,
        })
    }
});

async function pegarTodasEquipesPorModalidade(idModalidade) {
    return new Promise(function (resolve, reject) {
        equipes_juergs.findAndCountAll({
            where: {
                id_modalidade: idModalidade,
            },
            order: [
                ['ult_atualizacao', 'DESC']
            ],
        }).then(async (result) => {
            for (var i = 0; i < result.rows.length; i++) { // Repete para cada equipe encontrada.
                userCpfs = result.rows[i]['dataValues']['participantes_cadastrados'].split(';');
                userCpfs = userCpfs.slice(0, userCpfs.length - 1); // Coloca os cpf em uma lista de string
                result.rows[i]['dataValues']['participantes_cadastrados'] = userCpfs; // adiciona os cpfs ao resultado
                result.rows[i]['dataValues']['nomes_participantes'] = [];
                result.rows[i]['dataValues']['nomes_participantes'] = await pegarNomes(userCpfs);
            }
            resolve(result);
        })
    })
}

// Função para pegar todas as equipes de um dado usuario
async function pegarTodasEquipesPorUsuario(userCpf) {
    return new Promise(function (resolve, reject) {
        // Pega as IDs das minhas equipes
        cadastro_juergs.findAll({
            where: {
                cpf: userCpf,
            }
        }).then((user) => {
            equipesIds = user[0]['dataValues']['minhas_equipes'].split(';')
            equipesIds = equipesIds.slice(0, equipesIds.length - 1) // O ultimo elemento é vazio
            equipesIds = equipesIds.map(Number); // Converte um array de String para um array de Numbers

            equipes_juergs.findAndCountAll({
                where: {
                    id: equipesIds, // Passo todas as IDs
                },
                order: [
                    ['ult_atualizacao', 'DESC']
                ],
            }).then(async (result) => {
                for (var i = 0; i < result.rows.length; i++) { // Repete para cada equipe encontrada.
                    userCpfs = result.rows[i]['dataValues']['participantes_cadastrados'].split(';');
                    userCpfs = userCpfs.slice(0, userCpfs.length - 1); // Coloca os cpf em uma lista de string
                    result.rows[i]['dataValues']['participantes_cadastrados'] = userCpfs; // adiciona os cpfs ao resultado
                    result.rows[i]['dataValues']['nomes_participantes'] = [];
                    result.rows[i]['dataValues']['nomes_participantes'] = await pegarNomes(userCpfs);
                }
                resolve(result)
            })
        })
    })
}

// Dado os cpfs dos users, retorna uma lista com os nomes dos mesmos.
function pegarNomes(userCpfs) {
    return new Promise(function (resolve, reject) {
        var nomes_participantes = [];
        cadastro_juergs.findAll({ // pega os nomes de todos participantes da equipe
            attributes: ['nome'],
            where: {
                cpf: userCpfs,
            }
        }).then((result2) => {
            for (var j = 0; j < result2.length; j++) { // adiciona cada nome ao resultado
                nomes_participantes.push(result2[j]['dataValues']['nome']);
            }
            resolve(nomes_participantes);
        });
    })
}


module.exports = router;