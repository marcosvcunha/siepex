const express = require('express'),
    router = express.Router();
const {
    modalidades_juergs,
} = require('../../models');

router.put('/', async (req, res) => {
    retorno = await listar();
    if (retorno) {
        console.log(retorno);
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

async function listar(estudanteCpf) {
    return new Promise(function (resolve, reject) {
        modalidades_juergs.findAndCountAll().then((result) => {
            console.log(result)
            resolve(result);
        })
    })
}

module.exports = router;