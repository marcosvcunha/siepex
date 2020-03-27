/* jshint indent: 2 */

module.exports = function(sequelize, DataTypes) {
  return sequelize.define('tbl_contato_visitas', {
    id: {
      type: DataTypes.INTEGER(11),
      allowNull: false,
      primaryKey: true,
      autoIncrement: true
    },
    id_visitas: {
      type: DataTypes.INTEGER(11),
      allowNull: false,
      references: {
        model: 'tbl_visitas',
        key: 'id_visitas'
      }
    },
    nome: {
      type: DataTypes.STRING(50),
      allowNull: true
    },
    telefone_1: {
      type: DataTypes.STRING(30),
      allowNull: true
    },
    telefone_2: {
      type: DataTypes.STRING(30),
      allowNull: true
    },
    email: {
      type: DataTypes.STRING(50),
      allowNull: true
    }
  }, {
    tableName: 'tbl_contato_visitas'
  });
};
