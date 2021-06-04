const express = require('express'),
    router = express.Router();
const {
    jogos_juergs,
} = require('../../models');


router.put('/alterarJuiz/:idJogo/:novoJuiz', async (req, res) => {
    try{
        id = req.params.idJogo;
        novoJuiz = req.params.novoJuiz;
        console.log(id, novoJuiz);
        result = await jogos_juergs.update({
            nome_juiz: novoJuiz
        }, {
            where:{
                id: id
            }
        })
        res.json({
            status: 'sucesso'
        });

    }catch(e){
        res.json({
            status: 'erro'
        });
    }
})

module.exports = router;