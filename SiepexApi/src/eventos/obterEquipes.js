const express = require('express'),
    router = express.Router();
const {
    equipes_juergs,
    cadastro_juergs,
    participantes_rustica,
} = require('../../models');

router.put('/', async (req, res) => {
    // decide qual função usar com base no parametro passado em req
    if ('id_modalidade' in req.body) {
        idModalidade = parseInt(req.body['id_modalidade']);
        if('fase_atual' in req.body){
            faseAtual = (req.body['fase_atual'] != 'null') ? (parseInt(req.body['fase_atual'])) : '';
            equipes = await pegarTodasEquipesPorFase(idModalidade, faseAtual);
        }else
            equipes = await pegarTodasEquipesPorModalidade(idModalidade);
        res.json({
            data: equipes.rows,
            count: equipes.count,
        })
    } else if ('user_cpf' in req.body) {
        equipes = await pegarTodasEquipesPorUsuario(req.body['user_cpf']);
        res.json({
            data: equipes.rows,
            count: equipes.count,
        })
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

// Função para pegar todas as equipes de um dado usuario
async function pegarTodasEquipesPorUsuario(userCpf) {
    console.log('Pegando Equipes por usuario');
    return new Promise(function (resolve, reject) {
        // Pega as IDs das minhas equipes
        console.log("CPF: ")
        console.log(userCpf)
        cadastro_juergs.findAll({
            where: {
                cpf: userCpf,
            }
        }).then((user) => {
            equipesIds = user[0]['dataValues']['minhas_equipes'].split(';')
            equipesIds = equipesIds.slice(0, equipesIds.length - 1) // O ultimo elemento é vazio
            equipesIds = equipesIds.map(Number); // Converte um array de String para um array de Numbers
            console.log("IDs: ");
            console.log(equipesIds);
            equipes_juergs.findAndCountAll({
                where: {
                    id: equipesIds, // Passo todas as IDs
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
                resolve(result)
            })
        })
    })
}

async function pegarNomes(userCpfs) {
    // Faz desta forma (pega um nome por vez) para que os nomes estejam na mesma ordem dos cpfs.
    //console.log('CPF dos usurarios: ' + userCpfs.toString())
    var nomes_participantes = [];
    return new Promise(async function (resolve, reject) {
        for(var i = 0; i < userCpfs.length; i ++){
            var nome = await pegarNome(userCpfs[i]);
            nomes_participantes.push(nome);
        }
        //console.log('Terminando funcao');
        resolve(nomes_participantes);
    })
}

// async function pegarNomes(userCpfs){
//     var nomes_participantes = [];
//     users = (await cadastro_juergs.findAll({
//         where: {
//             cpf: userCpfs,
//         }
//     }));
//     console.log(users);
//     // for(i = 0; i < userCpfs.length; i++){
//     //     for(j = 0; j < userCpfs.length; j ++){
//     //         if(users[i][''])
//     //     }
//     // }
// }

function pegarNome(cpf){
    return new Promise(function (resolve, reject){
        cadastro_juergs.findByPk(cpf).then((result2) => {
            resolve(result2['dataValues']['nome']);
        });
    });
}

module.exports = router;