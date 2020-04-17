const express = require('express'),
    router = express.Router();
const {
    equipes_juergs,
} = require('../../models');

router.put('/', async (req, res) => {
    var equipe = await getEquipe(req.body['nome_equipe'], req.body['nome_modalidade']);
    console.log(equipe.count);
    if(equipe.count == 0){
        criarEquipe(req, res);
    }else{
        res.json({
            status:'erro',
            erro:'Equipe já existe'
        })
    }
})


// Confere já existe uma equipe com este nome.
async function getEquipe(equipe, modalidade){
    return new Promise( function (resolve, reject) {
        equipes_juergs.findAndCountAll({
            where: {nome_equipe: equipe, nome_modalidade: modalidade,}}).then((result) => {
                resolve(result);
        })
        }        
    )
}

// Confere se o participante já tem Equipe para esta modalidade.
async function partTemTime(equipe, modalidade){
    await equipes_juergs.findAndCountAll({
        where: {nome_equipe: equipe, nome_modalidade: modalidade,}}).then((result) => {
        console.log(result.count);
        if(result.count == 0)
            resolve(true);
        else
            return false;
    })
}

function criarEquipe(req, res){
    equipes_juergs.create(
            {
                id_modalidade: parseInt(req.body['id_modalidade']),
                nome_equipe: req.body['nome_equipe'],
                nome_modalidade:req.body['nome_modalidade'],
                maximo_participantes: req.body['maximo_participantes'],
                numero_participantes: 1,
            }
        ).then((result) => {
            console.log('Equipe criada')
            res.json({
                status:'sucesso',
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

async function listar() {
    return new Promise(function (resolve, reject) {
        equipes_juergs.findAndCountAll().then((result) => {
            resolve(result);
        })
    })
}

module.exports = router;