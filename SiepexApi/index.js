console.log('I am running!')

const express = require('express'),
  participante_rotas = require("./src/participante/participante_routes.js"),
  visitas_rotas = require("./src/eventos/visitas.js"),
  minicursos_rotas = require("./src/eventos/minicursos.js"),
  geral_rotas = require("./src/eventos/geral.js"),
  comissao_rotas = require("./src/comissao/comissao_routes"),
  trabalhos_rotas = require("./src/eventos/trabalhos.js"),
  cadastro_juergs_rotas = require("./src/eventos/cadastraJuergs.js"),
  obtem_participante_rotas = require("./src/eventos/obterParticipante.js"),
  obtem_modalidades_rotas = require("./src/eventos/obterModalidades.js"),
  bodyParser = require('body-parser');

const app = express();

var rawBodySaver = function (req, res, buf, encoding) {
  if (buf && buf.length) {
    req.rawBody = buf.toString(encoding || 'utf8');
  }
}

app.use(bodyParser.json({
  verify: rawBodySaver
}));

app.use(bodyParser.urlencoded({
  verify: rawBodySaver,
  extended: true
}));
app.use(bodyParser.raw({
  verify: rawBodySaver,
  type: '*/*'
}));

app.use('/participante', participante_rotas);
app.use('/visitas', visitas_rotas);
app.use('/minicursos', minicursos_rotas);
app.use('/geral', geral_rotas);
app.use('/comissao', comissao_rotas);
app.use("/trabalhos", trabalhos_rotas);
app.use("/cadastroJuergs", cadastro_juergs_rotas);
app.use("/obtemParticipante", obtem_participante_rotas);
app.use("/obtemModalidade", obtem_modalidades_rotas);
app.get('/', function (req, res) {
  res.json("the server is on")
})


app.listen(process.env.PORT || 5000, function () {
  console.log('Example app listening on port ', (process.env.PORT || 5000));
});