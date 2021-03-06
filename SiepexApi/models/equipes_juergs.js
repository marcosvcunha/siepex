
module.exports = function(sequelize, DataTypes){
    return sequelize.define('equipes_juergs', {
        id :{
            type: DataTypes.INTEGER(2),
            allowNull: false,
            primaryKey: true,
            autoIncrement: true,
        },
        id_modalidade:{
            type: DataTypes.INTEGER(2),
            allowNull: false,
        },
        fase_equipe:{
            type: DataTypes.INTEGER(2),
            allowNull: false,
        },
        nome_equipe:{
            type: DataTypes.STRING(30),
            allowNull: false,
        },
        nome_modalidade:{
            type: DataTypes.STRING(30),
            allowNull: false,
        },
        maximo_participantes:{
            type: DataTypes.INTEGER(2),
            allowNull: false,
        },
        numero_participantes:{
            type: DataTypes.INTEGER(2),
            allowNull: false,
        },
        cpf_capitao:{
            type: DataTypes.STRING(11),
            allowNull: false,
        },
        grupo: {
            type: DataTypes.STRING(10),
            allowNull: true,
        },
        data_cadastro:{
            type: DataTypes.DATE(11),
            allowNull: true,
        },
        ult_atualizacao:{
            type: DataTypes.DATE(11),
            allowNull: true,
        },
    },{
        tableName: 'equipes_juergs'
    }
    )
}