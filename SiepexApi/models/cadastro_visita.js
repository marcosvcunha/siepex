/* jshint indent: 2 */

module.exports = function(sequelize, DataTypes) {
  return sequelize.define('cadastro_visita', {
    id: {
      type: DataTypes.INTEGER(11),
      allowNull: false,
      primaryKey: true,
      autoIncrement: true
    },
    id_visita: {
      type: DataTypes.INTEGER(11),
      allowNull: true,
      references: {
        model: 'tbl_visitas',
        key: 'id_visitas'
      }
    },
    id_participante: {
      type: DataTypes.INTEGER(11),
      allowNull: true,
      references: {
        model: 'participante',
        key: 'id'
      }
    },
    datahora: {
      type: DataTypes.DATE,
      allowNull: true,
      defaultValue: sequelize.literal('CURRENT_TIMESTAMP')
    }
  }, {
    tableName: 'cadastro_visita'
  });
};
