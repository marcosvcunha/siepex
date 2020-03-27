/* jshint indent: 2 */

module.exports = function(sequelize, DataTypes) {
  return sequelize.define('tbl_visitas', {
    id_visitas: {
      type: DataTypes.INTEGER(11),
      allowNull: false,
      primaryKey: true,
      autoIncrement: true
    },
    km: {
      type: DataTypes.STRING(45),
      allowNull: true
    },
    km_total: {
      type: DataTypes.STRING(45),
      allowNull: true
    },
    deslocamento: {
      type: DataTypes.STRING(45),
      allowNull: true
    },
    saida: {
      type: DataTypes.STRING(45),
      allowNull: true
    },
    retorno: {
      type: DataTypes.STRING(45),
      allowNull: true
    }
  }, {
    tableName: 'tbl_visitas'
  });
};
