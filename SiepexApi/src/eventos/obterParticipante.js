const express = require('express'),
  router = express.Router();
const {
  cadastro_juergs,
} = require('../../models');

router.put('/', async (req, res) => {
      console.log(req.body['cpf']),
      retorno = await obter(req.body['cpf']);
    if (retorno) {
        console.log(retorno.cpf);
      res.json({
        status: 'ok',
        data: retorno.dataValues,
      })
    }
    else{
        res.json({
            status: 'nao_achou',
          })
    }
  });

async function obter(estudanteCpf) {
    return new Promise(function (resolve, reject) {
      cadastro_juergs.findByPk(estudanteCpf).then((result) => {
        console.log(result)
        resolve(result);
      })
    })
  }
  
  module.exports = router;