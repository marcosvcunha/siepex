/* jshint indent: 2 */

module.exports = function(sequelize, DataTypes) {
  return sequelize.define('tbl_locais_visitas', {
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
    local: {
      type: DataTypes.STRING(70),
      allowNull: true
    },
    inicio: {
      type: DataTypes.STRING(45),
      allowNull: true
    },
    tempo_visita: {
      type: DataTypes.STRING(45),
      allowNull: true
    },
    custo: {
      type: DataTypes.STRING(45),
      allowNull: true
    }
  }, {
    tableName: 'tbl_locais_visitas'
  });
};
