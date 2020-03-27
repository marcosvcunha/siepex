const
    express = require('express'),
    router = express.Router();
const {
    tbl_comissao_organizadora
} = require('../../models');

router.get('/', (req, res) => {
    tbl_comissao_organizadora.findAll().then((result) => {
        res.json(result);
    }).catch((err) => {
        res.json(String(err));
    });
}); //Listar todos
router.get('/:id', (req, res) => {
    tbl_comissao_organizadora.findByPk(req.params.id).then((result) => {
        res.json(result);
    }).catch((err) => {
        console.log(err)
        res.json(String(err))
    });
});



module.exports = router;