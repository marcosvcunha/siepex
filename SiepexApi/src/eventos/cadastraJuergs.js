/* const {Sequelize} = require('sequelize');
const sequelize = new Sequelize('siepex', 'root', 'admin', {
    host: 'localhost',
    dialect: 'mysql'
}); */
const express = require('express'),
    router = express.Router();
const {
  cadastro_juergs,
} = require('../../models');

router.put('/', (req, res) => {
  cadastro_juergs.create(
    {
    //cpf: Math.random().toString(36).substring(7),
    cpf: req.body['cpf'],
    nome:req.body['nome'],
    email: req.body['email'],
    instituicao : req.body['instituicao'],
    ind_uergs : req.body['indUergs'],
    campos_uergs: req.body['campusUergs'],
    tipo_participante : req.body['tipoParticipante'][0],
    ind_necessidades_especiais: req.body['indNecessidade'],
}).then((result) => {
      res.json(result);
  }).catch((err) => {
      console.log(err)
      res.json(String(err));
  });
});

module.exports = router;

/* const Postagem = sequelize.define('cadastro_juergs',{
    cpf: {
        type: Sequelize.STRING,
        primaryKey: true
      },
      nome: {
        //type: STRING(40),
        type: Sequelize.STRING,
      },
      email: {
        //type: STRING(40),
        type: Sequelize.STRING,
      },
      instituicao: {
        //type: STRING(10),
        type: Sequelize.STRING,
      },
      ind_uergs: {
        //type: BOOLEAN(1),
        type: Sequelize.STRING,
      },
      campos_uergs: {
        //type: STRING(20),
        type: Sequelize.STRING,
      },
      tipo_participante: {
        //type: CHAR(1),
        type: Sequelize.STRING,
      },
      ind_necessidades_especiais: {
        //type: BOOLEAN(1),
        type: Sequelize.STRING,
      },
      ult_atualizacao: {
        //type: DATE(11),
        type: Sequelize.STRING,
      }
},{
    timestamps: false,
}); */

/* router.create({
    cpf: Math.random().toString(36).substring(7),
    nome:'Paulo Steffen Machado',
    email: 'paulo-steffen@uergs.edu.br',
    instituicao : 'uegrs',
    ind_uergs : '1',
    campos_uergs: 'centro',
    tipo_participante : 'c',
    ind_necessidades_especiais: '0',

}); */

