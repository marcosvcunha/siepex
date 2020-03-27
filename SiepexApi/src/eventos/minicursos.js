const express = require('express'),
    router = express.Router();
const {
    tbl_minicursos,
    participante,
    tbl_visitas,
    cadastro_visita,
    cadastro_minicurso,
} = require('../../models');
participante.belongsToMany(tbl_minicursos, {
    through: {
        model: cadastro_minicurso,
        unique: false,
    },
    foreignKey: 'id_participante',
    constraints: false
});
participante.belongsToMany(tbl_visitas, {
    through: {
        model: cadastro_visita,
        unique: false,
    },
    foreignKey: 'id_participante',
    constraints: false
});
tbl_visitas.belongsToMany(participante, {
    through: {
        model: cadastro_visita,
        unique: false,
    },
    foreignKey: 'id_visita',
    constraints: false
});
tbl_minicursos.belongsToMany(participante, {
    through: {
        model: cadastro_minicurso,
        unique: false,
    },
    foreignKey: 'id_minicurso',
    constraints: false
});
router.get('/', (req, res) => {
    tbl_minicursos.findAll({
        order: [
            ['inicio', 'ASC'],
        ],
    }).then((result) => {
        res.json(result)
    }).catch((err) => {
        res.json(String(err))
    });
}); //Listar todos
router.get('/', (req, res) => {
    tbl_visitas.findAll({
        order: [
            ['saida', 'ASC'],
        ],
    }).then((result) => {
        res.json(result)
    }).catch((err) => {
        res.json(String(err))
    });
}); //Listar todos/

router.get('/:id', (req, res) => {
    tbl_minicursos.findByPk(req.params.id, {
        include: [participante]
    }).then((result) => {
        res.json(result)
    }).catch((err) => {
        console.log(err)
        res.json(String(err))
    });
});
router.get('/:id', (req, res) => {
    tbl_visitas.findByPk(req.params.id, {
        include: [participante]
    }).then((result) => {
        res.json(result)
    }).catch((err) => {
        console.log(err)
        res.json(String(err))
    });
});
router.get('/:id/participantes', (req, res) => {
    tbl_minicursos.findByPk(req.params.id, {
        attributes: [],
        include: [{
            model: participante, attributes: ['nome', 'cpf'], through: {
                attributes: []
            }
        }]
    }).then((result) => {
        res.json(result)
    }).catch((err) => {
        console.log(err)
        res.json(String(err))
    });
});
router.get('/:id/participantes', (req, res) => {
    tbl_visitas.findByPk(req.params.id, {
        attributes: [],
        include: [{
            model: participante, attributes: ['nome', 'cpf'], through: {
                attributes: []
            }
        }]
    }).then((result) => {
        res.json(result)
    }).catch((err) => {
        console.log(err)
        res.json(String(err))
    });
});
router.delete("/:id/liberar/:id_participante", (req, res) => {
    cadastro_minicurso.destroy({
        where: {
            id_minicurso: req.params.id,
            id_participante: req.params.id_participante
        }
    }).then(function (rowDeleted) { // rowDeleted will return number of rows deleted
        if (rowDeleted === 1) {
            console.log('Deleted successfully');
            tbl_minicursos.findByPk(req.params.id).then((minicurso) => {
                tbl_minicursos.update({
                    "vagas": minicurso.vagas + 1
                }, {
                    where: {
                        'id': req.params.id
                    }
                }).then(() => {
                    res.json({
                        status: "sucesso"
                    })
                })
            })
        } else {
            res.json({
                status: "sucesso, nada mudou"
            })
        }
    }, function (err) {
        console.log(err);
        res.json({
            status: "falha"
        })
    });
})
router.put('/:id/cadastrar', (req, res) => {
    //encerrado
    //return;
    tbl_minicursos.findByPk(req.params.id).then((minicurso) => {
        console.log(minicurso);
        if (minicurso.vagas < 1) {
            res.json({
                status: "falha, vagas esgotadas"
            })
            return;
        }
        participante.findByPk(req.body.id_participante, {
            include: [{
                model: tbl_minicursos,
                order: ['fim', 'DESC']
            },
            {
                model: tbl_visitas,
                order: ['fim', 'DESC']
            }]
        }).then((participante) => {
            if (participante['tbl_minicursos'].length != 0) {
                for (var i = 0; i != participante['tbl_minicursos'].length; i++) {
                    if (participante['tbl_minicursos'][i]['fim'] > minicurso['inicio']) {
                        console.log("ocupado");
                        res.json({
                            status: "Parece que você já está ocupado"
                        })
                        return false;
                    }
                }
            }
            if (participante['tbl_visitas'].length != 0) {
                for (var i = 0; i != participante['tbl_visitas'].length; i++) {
                    if (participante['tbl_visitas'][i]['retorno'] > minicurso['inicio']) {
                        console.log("ocupado");
                        res.json({
                            status: "Parece que você já está ocupado"
                        })
                        return false;
                    }
                }
            }

            cadastro_minicurso.findOrCreate({
                where: {
                    id_minicurso: minicurso['id'],
                    id_participante: participante['id']
                },
                defaults: {
                    id_minicurso: minicurso['id'],
                    id_participante: participante['id']
                }
            }).then(() => {
                minicurso.update({
                    "vagas": minicurso.vagas - 1
                }, {
                    where: {
                        'id': minicurso.id
                    }
                }).then(() => {
                    res.json({
                        status: "sucesso"
                    })
                })
            })
        }
        )
    }).catch((err) => {
        console.log(err)
        res.json({
            status: "erro",
            erro: String(err)
        })
    });
});
module.exports = router