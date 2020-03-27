/* jshint indent: 2 */

module.exports = function(sequelize, DataTypes) {
  return sequelize.define('tbl_trabalhos_aprovados', {
    id_trabalho: {
      type: DataTypes.INTEGER(11),
      allowNull: false,
      primaryKey: true
    },
    titulo: {
      type: DataTypes.STRING(2000),
      allowNull: true
    },
    modalidade: {
      type: DataTypes.STRING(1000),
      allowNull: true
    },
    autor: {
      type: DataTypes.STRING(1000),
      allowNull: true
    },
    demais_colaboradores: {
      type: DataTypes.STRING(2000),
      allowNull: true
    },
    tipo_apresentacao: {
      type: DataTypes.STRING(2000),
      allowNull: true
    },
    dia: {
      type: DataTypes.STRING(15),
      allowNull: true
    },
    hora: {
      type: DataTypes.STRING(25),
      allowNull: true
    },
    predio_sala: {
      type: DataTypes.STRING(10),
      allowNull: true
    },
    area_ensino: {
      type: DataTypes.STRING(1000),
      allowNull: true
    }
  }, {
    tableName: 'tbl_trabalhos_aprovados'
  });
};
