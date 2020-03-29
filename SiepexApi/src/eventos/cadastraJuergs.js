const express = require('express'),
  router = express.Router();
const {
  cadastro_juergs,
} = require('../../models');

router.put('/', (req, res) => {
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
      res.json({
        status: 'sucesso'
      })
    }).catch((err) => {
      console.log(err)
      res.json({
        status: 'erro',
        erro: String(err)
      })
    });
});

module.exports = router;

