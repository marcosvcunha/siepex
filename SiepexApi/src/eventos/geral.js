const express = require('express'),
    router = express.Router();
const {
    tbl_programacao,
} = require('../../models');

router.get('/', (req, res) => {
    tbl_programacao.findAll({
        order: [
            ['dia', 'ASC'], ['inicio', 'ASC'],
        ],
    }).then((result) => {
        res.json(result);
    }).catch((err) => {
        res.json(String(err));
    });
}); //Listar todos
router.get('/:id', (req, res) => {
    tbl_programacao.findByPk(req.params.id).then((result) => {
        res.json(result);
    }).catch((err) => {
        console.log(err)
        res.json(String(err))
    });
});

module.exports = router;