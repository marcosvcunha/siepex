const
    express = require('express'),
    router = express.Router();
const {
    participante,
    tbl_minicursos,
    cadastro_minicurso,
    tbl_visitas,
    cadastro_visita,
    tbl_contato_visitas,
    tbl_locais_visitas
} = require('../../models');
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
participante.belongsToMany(tbl_minicursos, {
    through: {
        model: cadastro_minicurso,
        unique: false,
    },
    foreignKey: 'id_participante',
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
    participante.findAll().then((result) => {
        res.json(result)
    }).catch((err) => {
        res.json(String(err))
    });
}); //Listar todos
router.post('/', (req, res) => {
    console.log(req.body)
    participante.findOrCreate({
        where: {
            cpf: req.body.cpf
        },
        defaults: req.body
    })
        .then(([user, created]) => {
            res.json(user.get({
                plain: true
            }))
        })
}); // Criar
router.get('/:id', (req, res) => {
    participante.findByPk(req.params.id).then((result) => {
        res.json(result)
    }).catch((err) => {
        res.json(String(err))
    });
}); //Buscar
router.get('/:id/minicursos', (req, res) => {
    participante.findByPk(req.params.id, {
        attributes: [],
        include: [tbl_minicursos]
    }).then((result) => {
        res.json(result)
    }).catch((err) => {
        res.json(String(err))
    });
});
router.get('/:id/visitas', (req, res) => {
    participante.findByPk(req.params.id, {
        attributes: [],
        include: [{
            model: tbl_visitas,
            include: [tbl_contato_visitas, tbl_locais_visitas]
        }],
    }).then((result) => {
        res.json(result)
    }).catch((err) => {
        res.json(String(err))
    });
});
router.get('/:cpf/login', (req, res) => {
    var senha = req.query.senha;
    participante.findOne({
        where: {
            "cpf": req.params.cpf
        }
    }).then((result) => {
        if (result) {

            if (senha == result.senha) {
                res.json(result)
            } else {
                res.send({
                    "erro": "Falha nas credenciais"
                })
            }
        } else {
            res.send({
                "erro": "Usuario não existente"
            })
        }
    }).catch((err) => {
        res.json(String(err))
    });
}); //Logar
router.put('/:id', (req, res) => {
    participante.update(req.body, {
        where: {
            'id': req.params.id
        }
    })
        .then(function (rowsUpdated) {
            res.json(rowsUpdated)
        })
        .catch((err) => {
            res.json({ "erro": String(err) })
        });

}); //Editar
router.delete('/:id', (req, res) => {
    res.json("not implemented")
}); //Deletar



module.exports = router;