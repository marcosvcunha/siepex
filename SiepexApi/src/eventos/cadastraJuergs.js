const {Sequelize} = require('sequelize');
const sequelize = new Sequelize('siepex', 'root', 'admin', {
    host: 'localhost',
    dialect: 'mysql'
});

sequelize.authenticate().then(function(){
    console.log('dalhe');
}).catch(function(erro){
    console.log('nao deu: ' + erro);
});

const Postagem = sequelize.define('cadastro_juergs',{
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
});

Postagem.create({
    cpf: '04058277092',
    nome:'Paulo Steffen Machado',
    email: 'paulo-steffen@uergs.edu.br',
    instituicao : 'uegrs',
    ind_uergs : '1',
    campos_uergs: 'centro',
    tipo_participante : 'c',
    ind_necessidades_especiais: '0',

});

