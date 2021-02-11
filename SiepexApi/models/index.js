'use strict';

const fs = require('fs');
const path = require('path');
const Sequelize = require('sequelize');
const cadastro_equipe = require('./cadastro_equipe');
const basename = path.basename(__filename);
const env = process.env.NODE_ENV || 'development';
const config = require(__dirname + '/../config/config.json')[env];
const db = {};

let sequelize;
if (config.use_env_variable) {
  sequelize = new Sequelize(process.env[config.use_env_variable], config);
} else {
  sequelize = new Sequelize(config.database, config.username, config.password, config);
}

fs
  .readdirSync(__dirname)
  .filter(file => {
    return (file.indexOf('.') !== 0) && (file !== basename) && (file.slice(-3) === '.js');
  })
  .forEach(file => {
    const model = sequelize['import'](path.join(__dirname, file));
    db[model.name] = model;
  });

Object.keys(db).forEach(modelName => {
  if (db[modelName].associate) {
    db[modelName].associate(db);
  }
});

db.sequelize = sequelize;
db.Sequelize = Sequelize;


db.cadastro_juergs.hasMany(db.cadastro_equipe, {foreignKey: 'cadastroJuergsCpf'});
db.cadastro_equipe.belongsTo(db.cadastro_juergs, {foreignKey: 'cadastroJuergsCpf'});
db.cadastro_equipe.belongsTo(db.equipes_juergs, {foreignKey: 'equipesJuergsId'});
db.equipes_juergs.hasMany(db.cadastro_equipe, {foreignKey: 'equipesJuergsId'});



db.cadastro_juergs.hasMany(db.equipes_juergs, {foreignKey: 'cpf_capitao'});
db.equipes_juergs.belongsTo(db.cadastro_juergs, {foreignKey: 'cpf_capitao'});

module.exports = db;
