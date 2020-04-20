const express = require('express'),
    router = express.Router();
const {
    equipes_juergs,
} = require('../../models');

router.put('/', async (req, res) => {
    var equipe = await getEquipe(req.body['nome_equipe'], req.body['nome_modalidade']);
    console.log(equipe.count);
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
    criarEquipe(req, res);
    return;
})

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

// Confere se o participante já tem Equipe para esta modalidade.
async function partTemTime(equipe, modalidade) {

}

function criarEquipe(req, res) {
    equipes_juergs.create(
        {
            id_modalidade: parseInt(req.body['id_modalidade']),
            nome_equipe: req.body['nome_equipe'],
            nome_modalidade: req.body['nome_modalidade'],
            maximo_participantes: req.body['maximo_participantes'],
            participantes_cadastrados: req.body['user_cpf'],
            numero_participantes: 1,
        }
    ).then((result) => {
        console.log('Equipe criada')
        res.json({
            status: 'sucesso',
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