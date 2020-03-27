const express = require('express'),
    router = express.Router();
const {
    tbl_trabalhos_aprovados,
} = require('../../models');

router.get('/', (req, res) => {
    tbl_trabalhos_aprovados.findAll({
        order: [
            ['hora', 'ASC'],
        ],
    }).then((result) => {
        res.json(result);
    }).catch((err) => {
        res.json(String(err));
    });
}); //Listar todos
router.get('/:id', (req, res) => {
    tbl_trabalhos_aprovados.findByPk(req.params.id).then((result) => {
        res.json(result);
    }).catch((err) => {
        console.log(err)
        res.json(String(err))
    });
});

module.exports = router;