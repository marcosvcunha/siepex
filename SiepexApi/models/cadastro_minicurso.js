/* jshint indent: 2 */

module.exports = function(sequelize, DataTypes) {
  return sequelize.define('cadastro_minicurso', {
    id: {
      type: DataTypes.INTEGER(11),
      allowNull: false,
      primaryKey: true,
      autoIncrement: true
    },
    id_minicurso: {
      type: DataTypes.INTEGER(11),
      allowNull: true,
      references: {
        model: 'tbl_minicursos',
        key: 'id'
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
      type: DataTypes.INTEGER(11),
      allowNull: true
    }
  }, {
    tableName: 'cadastro_minicurso'
  });
};
