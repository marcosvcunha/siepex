/* jshint indent: 2 */

module.exports = function(sequelize, DataTypes) {
  return sequelize.define('tbl_programacao', {
    id: {
      type: DataTypes.INTEGER(11),
      allowNull: false,
      primaryKey: true,
      autoIncrement: true
    },
    dia: {
      type: DataTypes.STRING(30),
      allowNull: true
    },
    programacao: {
      type: DataTypes.STRING(500),
      allowNull: true
    },
    inicio: {
      type: DataTypes.TIME,
      allowNull: true
    },
    fim: {
      type: DataTypes.TIME,
      allowNull: true
    },
    localizacao: {
      type: DataTypes.STRING(500),
      allowNull: true
    }
  }, {
    tableName: 'tbl_programacao'
  });
};
