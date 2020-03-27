/* jshint indent: 2 */

module.exports = function(sequelize, DataTypes) {
  return sequelize.define('participante', {
    id: {
      type: DataTypes.INTEGER(11),
      allowNull: false,
      primaryKey: true,
      autoIncrement: true
    },
    datahora_cadastro: {
      type: DataTypes.DATE,
      allowNull: true
    },
    migrado_em: {
      type: DataTypes.DATE,
      allowNull: true,
      defaultValue: sequelize.literal('CURRENT_TIMESTAMP')
    },
    atualizado_em: {
      type: DataTypes.DATE,
      allowNull: true
    },
    email: {
      type: DataTypes.STRING(60),
      allowNull: true
    },
    nome: {
      type: DataTypes.STRING(60),
      allowNull: true
    },
    rg: {
      type: DataTypes.STRING(45),
      allowNull: true
    },
    cpf: {
      type: DataTypes.STRING(45),
      allowNull: true
    },
    possui_necessidade_especial: {
      type: DataTypes.STRING(45),
      allowNull: true,
      defaultValue: 'Não'
    },
    categoria: {
      type: DataTypes.STRING(100),
      allowNull: true
    },
    unidade_ensino: {
      type: DataTypes.STRING(45),
      allowNull: true
    },
    utiliza_transporte_uergs: {
      type: DataTypes.STRING(45),
      allowNull: true
    },
    unidade_origem: {
      type: DataTypes.STRING(45),
      allowNull: true
    },
    concorda_termo: {
      type: DataTypes.STRING(45),
      allowNull: true
    },
    possui_necessidade_especial_transporte: {
      type: DataTypes.STRING(45),
      allowNull: true
    },
    desc_necessidade_especial_tranporte: {
      type: DataTypes.STRING(140),
      allowNull: true
    },
    utiliza_alimentacao_uergs: {
      type: DataTypes.STRING(45),
      allowNull: true
    },
    possui_necessidade_especial_alimentacao: {
      type: DataTypes.STRING(45),
      allowNull: true
    },
    desc_necessidade_especial_alimentacao: {
      type: DataTypes.STRING(140),
      allowNull: true
    },
    utiliza_alojamento_uergs: {
      type: DataTypes.STRING(45),
      allowNull: true
    },
    apresentara_trabalho: {
      type: DataTypes.STRING(45),
      allowNull: true
    },
    instituicao_ensino: {
      type: DataTypes.STRING(70),
      allowNull: true
    },
    id_trab1: {
      type: DataTypes.STRING(45),
      allowNull: true
    },
    id_trab2: {
      type: DataTypes.STRING(45),
      allowNull: true
    },
    senha: {
      type: DataTypes.STRING(45),
      allowNull: false,
      defaultValue: '123'
    }
  }, {
    tableName: 'participante'
  });
};
