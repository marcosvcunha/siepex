/* jshint indent: 2 */

module.exports = function(sequelize, DataTypes) {
  return sequelize.define('cadastro_juergs', {
    cpf: {
      type: DataTypes.STRING(11),
      allowNull: false,
      primaryKey: true,
      autoIncrement: false
    },
    nome: {
      type: DataTypes.STRING(40),
      allowNull: false,
    },
    email: {
      type: DataTypes.STRING(40),
      allowNull: false,
    },
    instituicao: {
      type: DataTypes.STRING(10),
      allowNull: true
    },
    ind_uergs: {
      type: DataTypes.BOOLEAN(1),
      allowNull: true
    },
    campos_uergs: {
      type: DataTypes.STRING(20),
      allowNull: true
    },
    tipo_participante: {
      type: DataTypes.CHAR(1),
      allowNull: true
    },
    ind_necessidades_especiais: {
      type: DataTypes.BOOLEAN(1),
      allowNull: true
    },
    minhas_equipes: {
      type: DataTypes.STRING(200),
      allowNull: true,
      defaultValue: ''
    },
    ult_atualizacao: {
      type: DataTypes.DATE(11),
      allowNull: true
    }
  }, {
    tableName: 'cadastro_juergs'
  });
};
