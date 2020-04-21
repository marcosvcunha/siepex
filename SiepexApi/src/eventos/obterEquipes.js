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
    }else if('user_cpf' in req.body){
        equipes = await pegarTodasEquipesPorUsuario(req.body['user_cpf']);
        console.log(equipes);
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
        }).then((result) => {
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
                }
            }).then((result) => {
                resolve(result)
            })
        })
    })
}


module.exports = router;