/* jshint indent: 2 */

module.exports = function(sequelize, DataTypes) {
    return sequelize.define('modalidades_juergs', {
      id: {
        type: DataTypes.INTEGER(2),
        allowNull: false,
        primaryKey: true,
        autoIncrement: true
      },
      nome_modalidade: {
        type: DataTypes.STRING(40),
        allowNull: false,
      },
      maximo_participantes: {
        type: DataTypes.STRING(40),
        allowNull: false,
      },
      ult_atualizacao: {
        type: DataTypes.DATE(11),
        allowNull: true
      }
    }, {
      tableName: 'modalidades_juergs'
    });
  };
  