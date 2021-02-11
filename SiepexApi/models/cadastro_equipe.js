/* jshint indent: 2 */

module.exports = function(sequelize, DataTypes) {
    return sequelize.define('cadastro_equipe', {
      id: {
        type: DataTypes.INTEGER(1),
        allowNull: false,
        primaryKey: true,
        autoIncrement: true
      },
      cadastroJuergsCpf: {
        type: DataTypes.STRING(11),
        allowNull: false,
      },
      equipesJuergsId: {
          type: DataTypes.INTEGER(1),
          allowNull: false,
      }
    }, {
      tableName: 'cadastro_equipe'
    });
  };
  