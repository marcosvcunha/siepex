/* jshint indent: 2 */

module.exports = function(sequelize, DataTypes) {
  return sequelize.define('tbl_comissao_organizadora', {
    id: {
      type: DataTypes.INTEGER(11),
      allowNull: false,
      primaryKey: true,
      autoIncrement: true
    },
    funcao: {
      type: DataTypes.STRING(500),
      allowNull: true
    },
    nome: {
      type: DataTypes.STRING(500),
      allowNull: true
    }
  }, {
    tableName: 'tbl_comissao_organizadora'
  });
};
