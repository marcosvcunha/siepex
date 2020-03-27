const express = require('express'),
    router = express.Router();
const {
    tbl_visitas,
    tbl_locais_visitas,
    tbl_contato_visitas,
    participante,
    cadastro_visita,
    cadastro_minicurso,
    tbl_minicursos,
} = require('../../models');
participante.belongsToMany(tbl_visitas, {
    through: {
        model: cadastro_visita,
        unique: false,
    },
    foreignKey: 'id_participante',
    constraints: false
});
participante.belongsToMany(tbl_minicursos, {
    through: {
        model: cadastro_minicurso,
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
tbl_visitas.hasMany(tbl_contato_visitas, {
    foreignKey: 'id_visitas',
});
tbl_visitas.hasMany(tbl_contato_visitas, {
    foreignKey: 'id_visitas',
});
tbl_contato_visitas.belongsTo(tbl_visitas, {
    foreignKey: 'id_visitas',
    targetKey: 'id_visitas'
});
tbl_visitas.hasMany(tbl_locais_visitas, {
    foreignKey: 'id_visitas',
});
tbl_locais_visitas.belongsTo(tbl_visitas, {
    foreignKey: 'id_visitas',
    targetKey: 'id_visitas'
});
router.get('/', (req, res) => {
    tbl_visitas.findAll({
        include: [tbl_contato_visitas, tbl_locais_visitas],
        order: [
            ['saida', 'ASC'],
        ],
    }).then((result) => {
        res.json(result)
    }).catch((err) => {
        res.json(String(err))
    });
}); //Listar todos
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
router.delete("/:id/liberar/:id_participante", (req, res) => {
    cadastro_visita.destroy({
        where: {
            id_visita: req.params.id,
            id_participante: req.params.id_participante
        }
    }).then(function (rowDeleted) { // rowDeleted will return number of rows deleted
        if (rowDeleted === 1) {
            console.log('Deleted successfully');
            res.json({
                status: "sucesso"
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
    tbl_visitas.findByPk(req.params.id).then((visita) => {
        console.log(visita);
        participante.findByPk(req.body.id_participante, {
            include: [{
                model: tbl_visitas,
                order: ['retorno', 'DESC']
            },
            {
                model: tbl_minicursos,
                order: ['fim', 'DESC']
            }]
        }).then((participante) => {
            if (participante['tbl_visitas'].length >= 1) {
                res.json({
                    status: "Você somente pode inscrever em uma visita."
                })
                return false;
            }

            if (participante['tbl_minicursos'].length != 0) {
                for (var i = 0; i != participante['tbl_minicursos'].length; i++) {
                    if (participante['tbl_minicursos'][i]['fim'] > visita['saida']) {
                        console.log("ocupado");
                        res.json({
                            status: "Parece que você já está ocupado"
                        })
                        return false;
                    }
                }
            }
            // res.json(visita);
            cadastro_visita.findOrCreate({
                where: {
                    id_visita: visita['id_visitas'],
                    id_participante: participante['id']
                },
                defaults: {
                    id_visita: visita['id'],
                    id_participante: participante['id']
                }
            }).then(() => {
                res.json({
                    status: "sucesso"
                })
            })

        })
    }).catch((err) => {
        console.log(err)
        res.json(String(err))
    });
});
router.get('/:id', (req, res) => {
    tbl_visitas.findByPk(req.params.id, {
        include: [tbl_contato_visitas, tbl_locais_visitas, participante]
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
module.exports = router