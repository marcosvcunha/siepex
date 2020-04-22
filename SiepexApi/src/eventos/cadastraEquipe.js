const express = require('express'),
    router = express.Router();
const {
    equipes_juergs,
    cadastro_juergs,
} = require('../../models');

router.put('/cadastra', async (req, res) => {
    var equipe = await getEquipe(req.body['nome_equipe'], req.body['nome_modalidade']);
    if (equipe.count != 0) {
        //criarEquipe(req, res);
        res.json({
            status: 'erro',
            erro: 'Equipe já existe'
        })
        return;
    }
    var equipesCadastradas = await listar(req.body['id_modalidade']);
    var lista = equipesCadastradas.rows;
    for (var i = 0; i != lista.length; i++) {
        var participantes = lista[i].participantes_cadastrados.split(';');
        for (var j = 0; j != participantes.length; j++) {
            if (participantes[j] == req.body['user_cpf']) {
                res.json({
                    status: 'erro',
                    erro: 'ja_cadastrado_na_modalidade'
                })
                return;
            }
        }
    }
    await criarEquipe(req, res);
    return;
})

router.put('/entra', async (req, res) => {
    equipeId = parseInt(req.body['equipe_id']);
    //userName = req['userName'];
    userCpf = req.body['user_cpf'];
    // Colocar o cpf e o nome do usuario na lista de membros da equipe.
    // Aumentar o número de participantes da equipe.
    equipes_juergs.findByPk(equipeId).then((equipe) => {
        equipes_juergs.update({
            numero_participantes: equipe.numero_participantes + 1,
            participantes_cadastrados: equipe.participantes_cadastrados + userCpf + ';',
        },{
            where: {
                id: equipeId,
            }
        }).then((result) => {
            cadastro_juergs.findByPk(userCpf).then((user) => {
                cadastro_juergs.update({
                    minhas_equipes: user.minhas_equipes + req.body['equipe_id'] + ';',
                },
                {
                    where: {
                    cpf: userCpf
                }})
            }).then((_) => {
            equipes_juergs.findByPk(equipeId).then( async (updatedEquipe) => {
                userCpfs = updatedEquipe['dataValues']['participantes_cadastrados'].split(';');
                userCpfs = userCpfs.slice(0, userCpfs.length - 1); // Coloca os cpf em uma lista de string
                updatedEquipe['dataValues']['participantes_cadastrados'] = userCpfs; // adiciona os cpfs ao resultado
                updatedEquipe['dataValues']['nomes_participantes'] = [];
                updatedEquipe['dataValues']['nomes_participantes'] = await pegarNomes(userCpfs);
                console.log(updatedEquipe);
                res.json({
                    status: 'sucesso',
                    data: updatedEquipe,
                });
            });
        })
        })
    }).catch((err) =>{
        res.json({
            status: 'erro',
        })
    }
    );


    //Colocar o id da equipe na lista de equipes do usuario
})

function pegarNomes(userCpfs) {
    return new Promise(function (resolve, reject) {
        var nomes_participantes = [];
        cadastro_juergs.findAll({ // pega os nomes de todos participantes da equipe
            attributes: ['nome'],
            where: {
                cpf: userCpfs,
            }
        }).then((result2) => {
            for (var j = 0; j < result2.length; j++) { // adiciona cada nome ao resultado
                nomes_participantes.push(result2[j]['dataValues']['nome']);
            }
            resolve(nomes_participantes);
        });
    })
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
    equipes_juergs.create(
        {
            id_modalidade: parseInt(req.body['id_modalidade']),
            nome_equipe: req.body['nome_equipe'],
            nome_modalidade: req.body['nome_modalidade'],
            maximo_participantes: req.body['maximo_participantes'],
            participantes_cadastrados: req.body['user_cpf'] + ';',
            numero_participantes: 1,
        }
    ).then((result) => {
         cadastro_juergs.findByPk(req.body['user_cpf']).then((participante)=> {
            cadastro_juergs.update({
                // Armazena o id da equipe cadastrada na lista de equipes do participante.
                minhas_equipes: participante.minhas_equipes + result['dataValues']['id'].toString() + ';'
            }, {
                where: {
                    'cpf' :req.body['user_cpf']
                }
            })
            
        }).then((otherResult) => {
            result['dataValues']['nomes_participantes'] = ['Marcos Cunha'];
            userCpfs = result['dataValues']['participantes_cadastrados'].split(';');
            userCpfs = userCpfs.slice(0, userCpfs.length - 1); // Coloca os cpf em uma lista de string
            result['dataValues']['participantes_cadastrados'] = userCpfs; // adiciona os cpfs ao resultado
            res.json({
                status: 'sucesso',
                data: result['dataValues'],
            })
        })

    }).catch((err) => {
        console.log("Erro na criação de equipe.")
        console.log(err)
        res.json({
            status: 'erro',
            erro: String(err),
        })
    })
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

module.exports = router;