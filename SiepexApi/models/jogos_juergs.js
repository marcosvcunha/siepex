
module.exports = function(sequelize, DataTypes){
    return sequelize.define('jogos_juergs', {
        time_a :{
            type: DataTypes.STRING(30),
            allowNull: false,
        },
        time_b :{
            type: DataTypes.STRING(30),
            allowNull: false,
        },
        id_time_a:{
            type: DataTypes.INTEGER(2),
            allowNull: false,
            primaryKey: true,
        },
        id_time_b:{
            type: DataTypes.INTEGER(2),
            allowNull: false,
            primaryKey: true,
        },
        resultado_a:{
            type: DataTypes.INTEGER(2),
            allowNull: false,
        },
        resultado_b:{
            type: DataTypes.INTEGER(2),
            allowNull: false,
        },
        encerrado:{
            type: DataTypes.BOOLEAN(1),
            allowNull: true,
        },
        modalidade:{
            type: DataTypes.INTEGER(2),
            allowNull: false,
        },
        etapa_jogo:{
            type: DataTypes.STRING(3),
            allowNull: true,
        },
        ult_atualizacao:{
            type: DataTypes.DATE(11),
            allowNull: true,
        },
    },{
        tableName: 'jogos_juergs'
    }
    )
}