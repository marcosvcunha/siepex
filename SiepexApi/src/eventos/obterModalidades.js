const express = require('express'),
    router = express.Router();
const {
    modalidades_juergs,
} = require('../../models');

router.put('/getAll', async (req, res) => {
    retorno = await listar();
    if (retorno) {
        res.json({
            status: 'ok',
            data: retorno.rows,
            count: retorno.count,
        })
    }
    else {
        res.json({
            status: 'nao_achou',
        })
    }
});

router.put('/nextFase', async (req, res) => {
    try{
        idEquipes = JSON.parse(req.body['equipes']) // Lista com id das equipes
        id = parseInt(req.body['id_modalidade']) // Id da modalidade
        fase_atual = parseInt(req.body['fase_atual']) // fase atual da modalidade

        modalidade = (await modalidades_juergs.findByPk(id))['dataValues'];

        // Este if confere se a fase atual no app do usuario é a mesma no DB
        // Pode ser que outro ADM já tenha avançado a competição de fase.
        if(modalidade['fase'] == fase_atual){
            // TODO:: Avançar a competição de fase e criar os respectivos jogos.
            switch(fase_atual){
                case 0:
                    // TODO: Vai da fase de inscrição para fase de grupos.
                    /*
                        Formato de variavel idEquipes:
                        [idEquipe A1, idEquipe A2, idEquipe A3, idEquipe B1, ..., idEquipe H2, idEquipe H3]
                        Jogos que devem ser criados:
                            A1 * A2
                            A2 * A3
                            A1 * A3
                            B1 * B2
                            B2 * B3
                            B1 * B3
                            ...
                        1 - Criar os Jogos:
                            (criar a tabela)
                            timeA   | timeB  | idTimeA | idTimeB | resulA | resulB | encerrado | modalidade   | jogo |
                            
                            TimeA1  | TimeA2 | idA1    | idA2    |   0    |    0   |   false   | idModalidade | g1 (fase de grupos jogo 1)
                            TimeA2  | TimeA3 | idA2    | idA3    |   0    |    0   |   false   | idModalidade | g2 (fase de grupos jogo 2)
                            TimeA1  | TimeA3 | idA1    | idA3    |   0    |    0   |   false   | idModalidade | g3 (fase de grupos jogo 3)
                            TimeB1  | TimeB2 | idB1    | idB2    |   0    |    0   |   false   | idModalidade | g4 (fase de grupos jogo 4)
                            ...
                            
                        2 - Marcar na coluna GRUPO da tabela de Equipes o respectivo grupo e posição. Ex:
                            Marcar na coluna GRUPO da equipe A1, GRUPO = A1
                            Marcar na coluna GRUPO da equipe A2, GRUPO = A2 
                            ...
                        3 - Passar a modalidade de fase:
                            modalidade.fase (no DB) = 1
                    */
                    break;
                case 1:
                    // TODO: Vai da fase de grupos para as Quartas de Final
                    break;
                case 2:
                    // TODO: Vai das Quartas de Final para a Semi Final
                    break;
                case 3:
                    // TODO: Vai da Semi para a Final
                    break;
                case 4:
                    // TODO: Encerra a competição.
                    break;
                default:
                    res.json({
                        status: 'erro',
                        erro: 'A competição já encerrou',
                    })
                    break;
            }

            res.json({
            status: 'sucesso',
            });
            return;

        }else{
            res.json({
                status: 'erro',
                erro: 'Modalidade nao esta mais nesta fase.'
            });
        } 
    }
    catch(e){
        res.json({
            status: 'erro',
        });
        return;
    }
});

async function listar(estudanteCpf) {
    return new Promise(function (resolve, reject) {
        modalidades_juergs.findAndCountAll().then((result) => {
            resolve(result);
        })
    })
}

module.exports = router;