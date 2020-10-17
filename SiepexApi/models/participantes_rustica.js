
module.exports = function(sequelize, DataTypes){
    return sequelize.define('participantes_rustica', {
        id :{
            type: DataTypes.INTEGER(2),
            allowNull: false,
            primaryKey: true,
            autoIncrement: true,
        },
        nome:{
            type: DataTypes.STRING(50),
            allowNull: false,
        },
        celular:{
            type: DataTypes.STRING(11),
            allowNull: false,
        },
        cpf:{
            type: DataTypes.STRING(11),
            allowNull: false,
        },
        unidade:{
            type: DataTypes.STRING(50),
            allowNull: false,
        },
        posicao:{
            type: DataTypes.INTEGER(1),
            allowNull: false,
        },
        tem_pos:{
            type: DataTypes.BOOLEAN(),
        },
        tempo:{
            type: DataTypes.INTEGER(2),
            allowNull: false,
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
        tableName: 'participantes_rustica'
    }
    )
}