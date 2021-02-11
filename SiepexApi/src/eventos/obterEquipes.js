const express = require('express'),
    router = express.Router();
const {
    equipes_juergs,
    cadastro_juergs,
    participantes_rustica,
    cadastro_equipe,
} = require('../../models');

// router.put('/', async (req, res) => {
//     // decide qual função usar com base no parametro passado em req
//     if ('id_modalidade' in req.body) {
//         idModalidade = parseInt(req.body['id_modalidade']);
//         if('fase_atual' in req.body){
//             faseAtual = (req.body['fase_atual'] != 'null') ? (parseInt(req.body['fase_atual'])) : '';
//             equipes = await pegarTodasEquipesPorFase(idModalidade, faseAtual);
//         }else
//             equipes = await pegarTodasEquipesPorModalidade(idModalidade);
//         res.json({
//             data: equipes.rows,
//             count: equipes.count,
//         })
//     } else if ('user_cpf' in req.body) {
//         equipes = await pegarTodasEquipesPorUsuario(req.body['user_cpf']);
//         res.json({
//             data: equipes.rows,
//             count: equipes.count,
//         })
//     }
// });

router.put('/porModalidade', async (req, res) => {
    try{
        idModalidade = parseInt(req.body['id_modalidade']);
        equipes = await pegarTodasEquipesPorModalidade2(idModalidade);
        res.json({
            status: "sucesso",
            data: equipes,
        });
    }catch(e){
        console.log("ERRO: " + e.toString());
        res.json({
            status: "erro",
        });
    }
});

router.put('/porFase', async (req, res) => {
    try{
        idModalidade = parseInt(req.body['id_modalidade']);
        fase = parseInt(req.body['fase_atual']);
        equipes = await pegarTodasEquipesPorFase(idModalidade, fase);
        
        res.json({
            status: "sucesso",
            data: equipes.rows,
            count: equipes.count,
        });
    }catch(e){
        res.json({
            status: "erro",
        });
    }
});

router.put('/porUser', async (req, res) => {
    try{
        cpf = req.body['user_cpf'];
        equipes = await pegarTodasEquipesPorUsuario2(cpf);
        res.json({
            status: "sucesso",
            data: equipes,
        });
    }catch(e){
        console.log(e.toString());
        res.json({
            status: "erro",
        });
    }
});

router.get('/rustica', async (req, res) => {
    participantes = await participantes_rustica.findAll({
        order: [
            ['id', 'asc'],
        ]
    });
    res.json({
        data: participantes,
    });
});

async function pegarTodasEquipesPorModalidade(idModalidade) {
    return new Promise(function (resolve, reject) {
        equipes_juergs.findAndCountAll({
            where: {
                id_modalidade: idModalidade,
            },
            include: [{
                model: cadastro_equipe,
                include: [{
                    model: cadastro_juergs,
                }]
            }],
            order: [
                ['data_cadastro', 'asc']
            ],
        }).then(async (result) => {
            for (var i = 0; i < result.rows.length; i++) { // Repete para cada equipe encontrada.
                userCpfs = result.rows[i]['dataValues']['participantes_cadastrados'].split(';');
                userCpfs = userCpfs.slice(0, userCpfs.length - 1); // Coloca os cpf em uma lista de string
                result.rows[i]['dataValues']['participantes_cadastrados'] = userCpfs; // adiciona os cpfs ao resultado

                userNomes = result.rows[i]['dataValues']['nomes_participantes'].split(';');
                userNomes = userNomes.slice(0, userNomes.length - 1); // Coloca os Nomes em uma lista de string
                result.rows[i]['dataValues']['nomes_participantes'] = userNomes; // adiciona os Nomes ao resultado
            }
            resolve(result);
        })
    })
}

async function pegarTodasEquipesPorModalidade2(idModalidade) {
    equipes = await equipes_juergs.findAndCountAll({
        where: {
            id_modalidade: idModalidade,
        },
        include: [{
            model: cadastro_equipe,
            include: [{
                model: cadastro_juergs,
            }]
        },{
            model: cadastro_juergs,
        }],
        order: [
            ['data_cadastro', 'asc']
        ],
    });

    return equipesToJson(equipes);
}


async function pegarTodasEquipesPorFase(idModalidade, faseAtual) {
    // Pega as equipes de uma determinada fase e modalidade.
    return new Promise(function (resolve, reject) {
        equipes_juergs.findAndCountAll({
            where: {
                id_modalidade: idModalidade,
                fase_equipe: faseAtual,
            },
            order: [
                ['data_cadastro', 'asc']
            ],
        }).then(async (result) => {
            for (var i = 0; i < result.rows.length; i++) { // Repete para cada equipe encontrada.
                userCpfs = result.rows[i]['dataValues']['participantes_cadastrados'].split(';');
                userCpfs = userCpfs.slice(0, userCpfs.length - 1); // Coloca os cpf em uma lista de string
                result.rows[i]['dataValues']['participantes_cadastrados'] = userCpfs; // adiciona os cpfs ao resultado
           
                userNomes = result.rows[i]['dataValues']['nomes_participantes'].split(';');
                userNomes = userNomes.slice(0, userNomes.length - 1); // Coloca os Nomes em uma lista de string
                result.rows[i]['dataValues']['nomes_participantes'] = userNomes; // adiciona os Nomes ao resultado
            }
            resolve(result);
        })
    })
}

async function pegarTodasEquipesPorUsuario2(userCpf) {
    equipes = await cadastro_equipe.findAndCountAll({
        where: {
            cadastroJuergsCpf: userCpf,
        },
        include: [{
            model: equipes_juergs,
            include: [{
                model: cadastro_equipe,
                include: [{
                    model: cadastro_juergs,
                }]
            },{
                model: cadastro_juergs,
            }]
        }]
    });

    equipesJson = [];

    equipes.rows.forEach(function(equipe, i){
        eq = equipe.dataValues.equipes_juerg.dataValues;
        cadastros = eq.cadastro_equipes;

        capitao = eq.cadastro_juerg.dataValues;
        equipeJson = {
            'id': eq.id,
            'nome_equipe': eq.nome_equipe,
            'id_modalidade': eq.id_modalidade,
            'nome_modalidade': eq.nome_modalidade,
            'maximo_participantes': eq.maximo_participantes,
            'numero_participantes': eq.numero_participantes,
            'participantes': [],
            'capitao': cadastroToJson(capitao),
        }

        cadastros.forEach(function(cadastro, i){
            cad = cadastro.dataValues.cadastro_juerg.dataValues;
            
            cadastroJson = cadastroToJson(cad);

            equipeJson['participantes'].push(cadastroJson);
        })

        equipesJson.push(equipeJson);
    });
    return equipesJson;
}


function pegarNome(cpf){
    return new Promise(function (resolve, reject){
        cadastro_juergs.findByPk(cpf).then((result2) => {
            resolve(result2['dataValues']['nome']);
        });
    });
}

function equipesToJson(equipes){
    // Recebe o que vem do banco da query de equpes com join de cadastro.
    // Retorna uma lista com as Equipes em Json
    // Dentro de cada equipes tem uma lista de membros da equipes também em Json

    equipesJson = []

    equipes['rows'].forEach(function(equipe, i){      
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