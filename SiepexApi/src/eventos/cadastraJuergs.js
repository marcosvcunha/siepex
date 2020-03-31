const express = require('express'),
  router = express.Router();
const {
  cadastro_juergs,
} = require('../../models');

router.put('/', async (req, res) => {
  console.log("Criando Cadastro"),
    console.log(req.body['cpf']),
    retorno = await obter(req.body['cpf']);
  if (retorno) {
    res.json({
      status: 'registro_existente',
    })
  }
  else {
    cadastro_juergs.create(
      {
        cpf: req.body['cpf'],
        nome: req.body['nome'],
        email: req.body['email'],
        instituicao: req.body['instituicao'],
        ind_uergs: req.body['indUergs'],
        campos_uergs: req.body['campusUergs'],
        tipo_participante: req.body['tipoParticipante'][0],
        ind_necessidades_especiais: req.body['indNecessidade'],
      }).then((result) => {
        console.log("Cadastro realizado com sucesso.")
        res.json({
          status: 'sucesso'
        })
      }).catch((err) => {
        console.log(err)
        res.json({
          status: 'erro',
          erro: String(err)
        })
      })
  };
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

