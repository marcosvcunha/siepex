const express = require('express'),
    router = express.Router();
const {
    equipes_juergs,
    cadastro_juergs,
    participantes_rustica,
} = require('../../models');
const { json } = require('body-parser');

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
    equipeId = parseInt(req.body['equipe_id']);
    //userName = req['userName'];
    userCpf = req.body['user_cpf'];
    // Colocar o cpf e o nome do usuario na lista de membros da equipe.
    // Aumentar o número de participantes da equipe.
    equipes_juergs.findByPk(equipeId).then((equipe) => {
        equipes_juergs.update({
            numero_participantes: equipe.numero_participantes + 1,
            participantes_cadastrados: equipe.participantes_cadastrados + userCpf + ';',
        }, {
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
                        }
                    })
            }).then((_) => {
                equipes_juergs.findByPk(equipeId).then(async (updatedEquipe) => {
                    userCpfs = updatedEquipe['dataValues']['participantes_cadastrados'].split(';');
                    userCpfs = userCpfs.slice(0, userCpfs.length - 1); // Coloca os cpf em uma lista de string
                    updatedEquipe['dataValues']['participantes_cadastrados'] = userCpfs; // adiciona os cpfs ao resultado
                    updatedEquipe['dataValues']['nomes_participantes'] = [];
                    updatedEquipe['dataValues']['nomes_participantes'] = await pegarNomes(userCpfs);
                    res.json({
                        status: 'sucesso',
                        data: updatedEquipe,
                    });
                });
            })
        })
    }).catch((err) => {
        res.json({
            status: 'erro',
        })
    }
    );


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
    await cadastro_juergs.findByPk(newCapCpf, {
        attributes: ['celular']
    }).then(async (user) => {
        await equipes_juergs.update({
            cpf_capitao: newCapCpf,
            celular_capitao: user['dataValues']['celular']
        }, { where: { id: equipeId } }).then((result) => {
            res.json({
                status: 'sucesso',
                newCapCel: user['dataValues']['celular']
            })
        }).catch((err) => res.json({ status: 'erro' }))

    }).catch((err) => res.json({ status: 'erro' }))

})

router.put('/remove', async (req, res) => {
    try {
        id = parseInt(req.body['equipe_id'])
        // Remove a Equipe da lista de Equipes de cada participante.
        await equipes_juergs.findByPk(id, {
            attributes: ['participantes_cadastrados'],
        }).then(async (participantes) => {
            userCpfs = participantes['dataValues']['participantes_cadastrados'].split(';');
            userCpfs = userCpfs.slice(0, userCpfs.length - 1);
            await cadastro_juergs.findAll({
                where: {
                    cpf: userCpfs
                },
            }, {
                attributes: ['minhas_equipes'],
            }).then(async (players) => {
                for (i = 0; i < players.length; i++) {
                    await cadastro_juergs.update({
                        'minhas_equipes': players[i].minhas_equipes.replace(id.toString() + ';', '')
                    }, {
                        where: {
                            cpf: players[i].cpf,
                        }
                    })
                }
            });
        }).catch((e) => {
            res.json({ status: 'erro' })
        })
        // Remove a Equipe
        equipes_juergs.destroy({
            where: {
                id: id,
            }
        }).then((result) => {
            res.json({ status: 'sucesso' });
        })
    } catch (e) {
        res.json({ status: 'erro' });
        return;
    }
})

router.put('/excludeMembers', async (req, res) => {
    try {
        id = parseInt(req.body['equipe_id']);
        userCpfs = JSON.parse(req.body['members_cpf']);

        // Apagar Equipe da lista de Equipe dos Membros excluidos.
        await cadastro_juergs.findAll({
            where: {
                cpf: userCpfs
            },
            attributes: ['cpf', 'minhas_equipes']
        }).then(async (users) => {
            for (i = 0; i < users.length; i++) {
                await cadastro_juergs.update({
                    'minhas_equipes': users[i].minhas_equipes.replace(id + ';', ''),
                }, {
                    where: {
                        cpf: users[i].cpf,
                    }
                })
            }

        }).catch((e) => {
            res.json({
                status: 'erro'
            });
            return;
        });
        // Apagar cpf dos membros excluidos da lista de participantes da equipe e mudar número de participantes na equipe.
        await equipes_juergs.findByPk(id, {
            attributes: ['numero_participantes', 'participantes_cadastrados'],
        }).then(async (equipe) => {
            newMemberList = equipe.participantes_cadastrados;
            for (i = 0; i < userCpfs.length; i++) {
                newMemberList = newMemberList.replace(userCpfs[i] + ';', '');
            }
            await equipes_juergs.update({
                'participantes_cadastrados': newMemberList,
                'numero_participantes': equipe.numero_participantes - userCpfs.length,
            }, {
                where: {
                    id: id,
                }
            })
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
    equipes_juergs.create(
        {
            id_modalidade: parseInt(req.body['id_modalidade']),
            nome_equipe: req.body['nome_equipe'],
            nome_modalidade: req.body['nome_modalidade'],
            maximo_participantes: req.body['maximo_participantes'],
            participantes_cadastrados: req.body['user_cpf'] + ';',
            numero_participantes: 1,
            cpf_capitao: req.body['user_cpf'],
            celular_capitao: req.body['user_cel'],
        }
    ).then((result) => {
        cadastro_juergs.findByPk(req.body['user_cpf']).then((participante) => {
            cadastro_juergs.update({
                // Armazena o id da equipe cadastrada na lista de equipes do participante.
                minhas_equipes: participante.minhas_equipes + result['dataValues']['id'].toString() + ';'
            }, {
                where: {
                    'cpf': req.body['user_cpf']
                }
            })

        }).then((otherResult) => {
            result['dataValues']['nomes_participantes'] = ['Teste Teste'];
            userCpfs = result['dataValues']['participantes_cadastrados'].split(';');
            userCpfs = userCpfs.slice(0, userCpfs.length - 1); // Coloca os cpf em uma lista de string
            result['dataValues']['participantes_cadastrados'] = userCpfs; // adiciona os cpfs ao resultado
            result['dataValues']['cpf_capitao'] = req.body['user_cpf'],
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