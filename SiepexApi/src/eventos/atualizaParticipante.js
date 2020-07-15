const express = require('express'),
  router = express.Router();
const {
  cadastro_juergs,
} = require('../../models');

router.put('/', async (req, res) => {
  console.log("Criando Cadastro"),
    console.log(req.body['cpf']),
    retorno = await obter(req.body['cpf']);
  if (!retorno) {
    res.json({
      status: 'registro_inexistente',
    })
  }
  else {
    cadastro_juergs.update(
      {
        nome: req.body['nome'],
        email: req.body['email'],
        instituicao: req.body['instituicao'],
        celular : req.body['celular'],
        ind_uergs: req.body['indUergs'],
        campos_uergs: req.body['campusUergs'],
        tipo_participante: req.body['tipoParticipante'],
        ind_necessidades_especiais: req.body['indNecessidade'],
        modalidades_juiz: req.body['modalidadesJuiz'],
      },{
          where:{
              cpf: req.body['cpf']
          }
      }).then((result) => {
        console.log("Update realizado com sucesso.")
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

