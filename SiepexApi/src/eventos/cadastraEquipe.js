const express = require('express'),
    router = express.Router();
const {
    equipes_juergs,
    cadastro_juergs,
    participantes_rustica,
    cadastro_equipe,
    Sequelize,
} = require('../../models');

const{ Op } = require("sequelize");

const { json } = require('body-parser');

router.put('/cadastra', async (req, res) => {
    try {
        var equipe = await getEquipe(req.body['nome_equipe'], req.body['nome_modalidade']);

        if (equipe.count != 0) {
            console.log('ERRRO!')
            res.json({
                status: 'erro',
                erro: 'Equipe já existe'
            })
            return;
        }

        //TODO: Pode ser conveniente conferir se o usuário já não possui equipe para a modalidade, entretanto, o app deve testar isso.
        equipe = await criarEquipe(req, res);
        
        newEquipe = (await equipes_juergs.findAll({
            where: {
                id: equipe.id,
            },
            include: [{
                model: cadastro_equipe,
                include: [{
                    model: cadastro_juergs,
                }],
            },{
                model: cadastro_juergs,
            }],
        }));
    
        
        console.log(newEquipe);
        newEquipeJson = equipesToJson(newEquipe)[0];


        res.json({
            status: 'sucesso',
            data: newEquipeJson,
        })
        return;
    } catch (e) {
        console.log('Erro ao criar equipe: ' + e.toString());
        res.json({
            status: 'erro',
            erro: 'Erro desconhecido'
        })
        return;
    }
})

router.put('/cadastraRustica', async (req, res) => {
    nome = req.body['nome'];
    celular = req.body['celular'];
    cpf = req.body['cpf'];
    unidade = req.body['unidade'];

    try {
        result = await participantes_rustica.findAndCountAll({
            where: { 'cpf': cpf },

        });
        if (result.count != 0) {
            res.json({
                status: 'erro',
                erro: 'participante cadastrado',
            });
            return;
        } else {
            await participantes_rustica.create({
                nome: nome,
                celular: celular,
                cpf: cpf,
                unidade: unidade,
                posicao: 0,
                tempo: 0,
            });
            res.json({
                status: 'sucesso',
            });
        }
    } catch (err) {
        console.log('Erro ao cadastrar participante na rustica !!!!!!');
        console.log(err.toString());
        res.json({
            status: 'erro',
            erro: 'erro desconhecido',
        });
        return;
    }
});

router.put('/updateRustica', async (req, res) => {
    try {
        data = JSON.parse(req.body.data);
        for (i = 0; i < data.length; i++) {
            await participantes_rustica.update(
                {
                    tem_pos: data[i]['temPos'],
                    posicao: data[i]['posicao'],
                    tempo: data[i]['tempo'],
                }, {
                where: {
                    cpf: data[i]['cpf'],
                }
            }
            );
        }
        res.json({
            status: 'sucesso',
        });
    } catch (e) {
        res.json({
            status: 'erro',
            erro: 'erro desconhecido',
        });
    }
});

router.put('/entra', async (req, res) => {
    try{
    equipeId = parseInt(req.body['equipe_id']);
    userCpf = req.body['user_cpf'];

    equipe = (await equipes_juergs.findByPk(equipeId))['dataValues'];

    updatedEquipe = await equipes_juergs.update({
        numero_participantes: equipe['numero_participantes'] + 1,
    }, {
        where: {
            id: equipeId,
        }
    });

    await cadastro_equipe.create({
        cadastroJuergsCpf: userCpf,
        equipesJuergsId: equipeId,
    });
        res.json({
            status:'successo',
            data: updatedEquipe,
        });

    }catch(e){
        res.json({
            status:'erro',
            erro: 'Erro desconhecido',
        });
    }
    //Colocar o id da equipe na lista de equipes do usuario
})

router.put('/changeName', async (req, res) => {
    var equipe = await getEquipe(req.body['nome_equipe'], req.body['nome_modalidade']);
    if (equipe.count != 0) {
        //criarEquipe(req, res);
        res.json({
            status: 'erro',
            erro: 'Equipe já existe'
        })
        return;
    } else {
        equipes_juergs.update({
            nome_equipe: req.body['nome_equipe'],
        }, {
            where: {
                id: parseInt(req.body['id_equipe']),
            }
        }).then((resul) => {
            res.json({
                status: 'sucesso',
            })
            return;
        }).catch((err) => {
            res.json({
                status: 'erro',
            })
            return;
        })
    }
    return;
})

router.put('/changeCaptain', async (req, res) => {
    newCapCpf = req.body['newcap_cpf'];
    equipeId = parseInt(req.body['equipe_id']);

    try{
    await equipes_juergs.update({
        cpf_capitao: newCapCpf,
    }, {
        where: {
            id: equipeId,
        }
    });
    res.json({
        'status':'sucesso',
    });
}catch(e){
        res.json({
            'status':'erro',
            'erro':'erro desconhecido',
        });
    }

})

router.put('/remove', async (req, res) => {
    try {
        equipeId = parseInt(req.body['equipe_id'])
        // Remove a Equipe da lista de Equipes de cada participante.
        await cadastro_equipe.destroy({
            where: {
                equipesJuergsId: equipeId,
            }
        });

        await equipes_juergs.destroy({
            where: {
                id: equipeId,
            }
        });

        res.json({
            status: 'sucesso',
        });

    } catch (e) {
        res.json({ status: 'erro' });
        return;
    }
})

router.put('/excludeMembers', async (req, res) => {
    try {
        equipeId = parseInt(req.body['equipe_id']);
        userCpfs = JSON.parse(req.body['members_cpf']);
        numeroParticipantesExcluidos = userCpfs.length.toString();

        await cadastro_equipe.destroy({
            where: {
                equipesJuergsId: equipeId,
                cadastroJuergsCpf: {
                    [Op.in]: userCpfs,
                }
            }
        });

        await equipes_juergs.update({
            numero_participantes: Sequelize.literal('numero_participantes - ' + numeroParticipantesExcluidos),
        },{
            where: {
                id: equipeId,
            }
        })

        res.json({
            status: 'sucesso',
        });
        return;
    } catch (e) {
        console.log('Erro ao excluir membros: ' + e.toString())
        res.json({
            status: 'erro'
        });
        return;
    }
})

// Pega o número de participantes da rústica
async function countRustica() {
    result = await equipes_juergs.findAndCountAll({
        where: { nome_modalidade: 'Rústica' }
    });
    return result.count;
}



// Confere já existe uma equipe com este nome.
async function getEquipe(equipe, modalidade) {
    return new Promise(function (resolve, reject) {
        equipes_juergs.findAndCountAll({
            where: { nome_equipe: equipe, nome_modalidade: modalidade, }
        }).then((result) => {
            resolve(result);
        })
    }
    )
}

async function criarEquipe(req, res) {
    result = await equipes_juergs.create(
        {
            id_modalidade: parseInt(req.body['id_modalidade']),
            nome_equipe: req.body['nome_equipe'],
            nome_modalidade: req.body['nome_modalidade'],
            maximo_participantes: req.body['maximo_participantes'],
            numero_participantes: 1,
            cpf_capitao: req.body['user_cpf'],
            fase_equipe: 0,
        }
    );
    await cadastro_equipe.create({
        cadastroJuergsCpf: req.body['user_cpf'],
        equipesJuergsId: result['dataValues']['id'],
    });
    return result['dataValues'];
}

async function listar(id) {
    return new Promise(function (resolve, reject) {
        equipes_juergs.findAndCountAll({
            where: { id_modalidade: id },
        }).then((result) => {
            resolve(result);
        })
    })
}

function equipesToJson(equipes){
    // Recebe o que vem do banco da query de equpes com join de cadastro.
    // Retorna uma lista com as Equipes em Json
    // Dentro de cada equipes tem uma lista de membros da equipes também em Json

    equipesJson = []

    equipes.forEach(function(equipe, i){      
        capitao = equipe.dataValues.cadastro_juerg.dataValues;
        
        equipeJson = {
            'id':equipe['dataValues']['id'],
            'id_modalidade': equipe['dataValues']['id_modalidade'],
            'nome_equipe': equipe['dataValues']['nome_equipe'],
            'nome_modalidade': equipe['dataValues']['nome_modalidade'],
            'maximo_participantes': equipe['dataValues']['maximo_participantes'],
            'numero_participantes': equipe['dataValues']['numero_participantes'],
            // 'numero_rustica': 0,
            // 'cpf_capitao': equipe['dataValues']['cpf_capitao'],
            // 'celular_capitao': equipe['dataValues']['celular_capitao'],
            'participantes': [],
            'capitao': cadastroToJson(capitao),
        }
        
        cadastros = equipe['dataValues']['cadastro_equipes']
        
        cadastros.forEach(function(cadastro, i){
            user = cadastro['dataValues']['cadastro_juerg'].dataValues
            userJson = cadastroToJson(user);
            equipeJson['participantes'].push(userJson);
        })
        equipesJson.push(equipeJson);
    })
    return equipesJson;
}

function cadastroToJson(cad){
    return {
        'cpf': cad.cpf,
        'nome': cad.nome,
        'email': cad.email,
        'instituicao': cad.instituicao,
        'ind_uergs': cad.ind_uergs,
        'campos_uergs': cad.campos_uergs,
        'tipo_participante': cad.tipo_participante,
        'ind_necessidades_especiais': cad.ind_necessidades_especiais,
        'celular': cad.celular,
        'modalidade_juiz': cad.modalidade_juiz,
    }
}

module.exports = router;