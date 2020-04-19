const express = require('express'),
    router = express.Router();
const {
    equipes_juergs,
} = require('../../models');

router.put('/', async (req, res) => {
    idModalidade = parseInt(req.body['id_modalidade']);
    equipes = await pegarTodasEquipes(idModalidade);
    res.json({
        data: equipes.rows,
        count: equipes.count,
    })
});

async function pegarTodasEquipes(idModalidade) {
    return new Promise(function (resolve, reject) {
        equipes_juergs.findAndCountAll({
            where:{
                id_modalidade:idModalidade,
            },
            order:[
                ['ult_atualizacao', 'DESC']
            ],
        }).then((result) => {
            resolve(result);
        })
    })
}

module.exports = router;