import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:siepex/models/serializeJuergs.dart';
import 'package:siepex/src/config.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:email_validator/email_validator.dart';
// import 'package:intl/intl.dart';

class PerfilParticipante extends StatefulWidget {
  final Widget child;
  PerfilParticipante({Key key, this.child}) : super(key: key);

  @override
  _CadastraParticipanteState createState() => _CadastraParticipanteState();
}

class _CadastraParticipanteState extends State<PerfilParticipante> {
  @override
  Widget build(BuildContext context) {
    return corpo(context);
  }

  bool _loading = false;
  String cpfError = null;
  String nomeError = null;
  String emailError = null;
  String instError = null;

  //checkbox
  bool futbol = false;
  bool handbol = false;
  bool volei = false;
  bool rustica = false;

  TextEditingController txtNome = TextEditingController(text: userJuergs.nome);

  TextEditingController txtCpf = TextEditingController(text: userJuergs.cpf);

  TextEditingController txtCelular =
      TextEditingController(text: userJuergs.celular);

  TextEditingController txtEmail =
      TextEditingController(text: userJuergs.email);

  TextEditingController txtInstituicao =
      TextEditingController(text: userJuergs.instituicao);

  bool checkIndUergs;

  bool checkEhNecessitado;

  String comboTipoParticipante = userJuergs.tipoParticipante;

  var cpfMask = new MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});

  var celularMask = new MaskTextInputFormatter(
      mask: '(##)#####-####', filter: {"#": RegExp(r'[0-9]')});

  var _errorText = null;
  bool _isLoading = false;
  bool entrou = false;

  bool toBoolean(String str) {
    if (str == "true") {
      return true;
    }
    return false;
  }

  void setaModalidadeJuiz(String modalidade) {
    if (modalidade != null) {
      if (modalidade.contains('Volei')) {
        this.volei = true;
      }
      if (modalidade.contains('Futebol')) {
        this.futbol = true;
      }
      if (modalidade.contains('Handebol')) {
        this.handbol = true;
      }
      if (modalidade.contains('Rustica')) {
        this.rustica = true;
      }
    }
  }

  bool cpfVerifier(String cpf) {
    if (!CPFValidator.isValid(cpf)) {
      _errorText = "Cpf invalido!";
      setState(() {});
      return false;
    } else {
      _errorText = null;
      setState(() {});
      return true;
    }
  }

  Widget camposIndUergs() {
    if (this.checkIndUergs) {
      return Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: TextField(
          decoration:
              InputDecoration(labelText: 'Campus', errorText: instError),
          controller: txtInstituicao,
          keyboardType: TextInputType.text,
          style:
              TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.w400),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: TextField(
          decoration:
              InputDecoration(labelText: 'Instituição', errorText: instError),
          controller: txtInstituicao,
          keyboardType: TextInputType.text,
          style:
              TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.w400),
        ),
      );
    }
  }

  Widget dropDown(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Text(
              "Tipo Participante ",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16.0,
              ),
            ),
          ),
          selectTipoParticipante(),
        ],
      ),
    );
  }

  Widget selectTipoParticipante(){
    if(userJuergs.tipoParticipante == "ADM"){
      return Text('ADM', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16));
    }else{
      return Listener(
          onPointerDown: (_) => FocusScope.of(context).unfocus(),
          child: DropdownButton<String>(
            value: comboTipoParticipante,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.lightBlue),
            underline: Container(height: 2, color: Colors.lightBlue),
            onChanged: (String newValue) {
              setState(() {
                comboTipoParticipante = newValue;
              });
            },
            items: <String>[
              'Atleta',
              'Espectador',
              'Juiz',
              'Corpo Docente',
              'Auxiliar'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        );
    }
  }

  validaCampos(Estudante estudante) {
    bool valido = true;
    if (!CPFValidator.isValid(estudante.cpf)) {
      cpfError = 'CPF inválido';
      valido = false;
    } else
      cpfError = null;
    if (!EmailValidator.validate(estudante.email)) {
      emailError = 'Email é Inválido';
      valido = false;
    } else
      emailError = null;
    if (estudante.nome.isEmpty) {
      nomeError = 'Nome é obrigatório';
      valido = false;
    } else
      nomeError = null;
    if (estudante.instituicao.isEmpty) {
      instError = 'Instituição é obrigatório';
      valido = false;
    } else {
      if (estudante.instituicao == "Uergs" && estudante.campoUergs.isEmpty) {
        instError = 'Campus é obrigatório';
        valido = false;
      } else
        instError = null;
    }
    if (estudante.nome.isNotEmpty) {
      if (!estudante.nome.contains(" ")) {
        nomeError = 'Digite o nome completo';
        valido = false;
      } else {
        nomeError = null;
      }
    }
    setState(() {});
    return valido;
  }

  Widget juizCheckCox() {
    if (comboTipoParticipante == 'Juiz') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "Futsal",
            style: TextStyle(color: Colors.lightBlue),
          ),
          Checkbox(
            value: futbol,
            onChanged: (bool value) {
              setState(() {
                futbol = value;
              });
            },
          ),
          Text(
            "Vôlei",
            style: TextStyle(color: Colors.lightBlue),
          ),
          Checkbox(
            value: volei,
            onChanged: (bool value) {
              setState(() {
                volei = value;
              });
            },
          ),
          Text(
            "Handebol",
            style: TextStyle(color: Colors.lightBlue),
          ),
          Checkbox(
            value: handbol,
            onChanged: (bool value) {
              setState(() {
                handbol = value;
              });
            },
          ),
          Text(
            "Rústica",
            style: TextStyle(color: Colors.lightBlue),
          ),
          Checkbox(
            value: rustica,
            onChanged: (bool value) {
              setState(() {
                rustica = value;
              });
            },
          ),
        ],
      );
    } else {
      return Row();
    }
  }

  Widget corpo(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: new Text(
          'Meu Pefil',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: _loading ? loadingScreen() : body(),
    );
  }

  Widget loadingScreen() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Future atualizar(Estudante estudante, BuildContext context) async {
    estudante.cpf = (estudante.cpf.replaceAll(".", "")).replaceAll("-", "");
    if (estudante.celular != null) {
      estudante.celular = estudante.celular
          .replaceAll("-", "")
          .replaceAll("(", "")
          .replaceAll(")", "");
    } else {
      //api nao aceita null aparentemente :(
      estudante.celular = '0';
    }
    estudante.cpf = (estudante.cpf.replaceAll(".", "")).replaceAll("-", "");
    if (comboTipoParticipante != 'Juiz') {
      futbol = false;
      handbol = false;
      rustica = false;
      volei = false;
    } else {
      String modalidadesJuiz = '';
      if (futbol == true) {
        modalidadesJuiz += 'Futebol, ';
      }
      if (handbol == true) {
        modalidadesJuiz += 'Handebol, ';
      }
      if (volei == true) {
        modalidadesJuiz += 'Volei, ';
      }
      if (rustica == true) {
        modalidadesJuiz += 'Rustica,';
      }
      if (modalidadesJuiz.isNotEmpty) {
        estudante.modalidadesJuiz = modalidadesJuiz;
      } else {
        estudante.modalidadesJuiz = 'null';
      }
    }

    if (!validaCampos(estudante)) {
      print("caiu");
      return false;
    }
    print("passou");
    try {
      print("Enviando request.");
      setState(() {
        _loading = true;
      });
      var resposta =
          jsonDecode((await http.put(baseUrl + 'atualizaParticipante/', body: {
        'nome': estudante.nome,
        'cpf': estudante.cpf,
        'email': estudante.email,
        'instituicao': estudante.instituicao,
        'campusUergs': estudante.campoUergs,
        'indUergs': estudante.indUergs,
        'indNecessidade': estudante.indNecessidade,
        'celular': estudante.celular,
        'tipoParticipante': estudante.tipoParticipante,
        'modalidadesJuiz': estudante.modalidadesJuiz.toString()
      }))
              .body);
      setState(() {
        _loading = false;
      });
      print("Request enviado.");
      print(resposta);
      if (resposta['status'] != null) {
        if (resposta['status'] == 'sucesso') {
          userJuergs = estudante;
          userJuergs.isOn = true; // Loga usuario
          Navigator.popUntil(context, ModalRoute.withName('inicio'));
          Navigator.pushNamed(context, 'inicioJuergs');
        } else if (resposta['status'] == 'erro') {
          Alert(context: context, title: 'Erro no cadastro').show();
        } else if (resposta['status'] == 'registro_inexistente') {
          Alert(context: context, title: 'Participante não cadastrado').show();
        }
      }
    } catch (e) {
      print(e);
      Alert(context: context, title: "Erro", desc: "Falha no Cadastro").show();
    }
  }

  Widget body() {
    if (this.entrou == false) {
      this.checkIndUergs = toBoolean(userJuergs.indUergs);
      this.checkEhNecessitado = toBoolean(userJuergs.indNecessidade);
      this.txtCpf =
          TextEditingController(text: CPFValidator.format(userJuergs.cpf));
      setaModalidadeJuiz(userJuergs.modalidadesJuiz);
      setState(() {});
      this.entrou = true;
    }
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: TextField(
            decoration:
                InputDecoration(labelText: 'Nome', errorText: nomeError),
            controller: txtNome,
            keyboardType: TextInputType.text,
            style:
                TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.w400),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: TextField(
            decoration: InputDecoration(labelText: 'CPF', errorText: cpfError),
            controller: txtCpf,
            inputFormatters: [cpfMask],
            keyboardType: TextInputType.number,
            enabled: false,
            style:
                TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.w400),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: TextField(
            decoration:
                InputDecoration(labelText: 'Email', errorText: emailError),
            controller: txtEmail,
            keyboardType: TextInputType.text,
            style:
                TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.w400),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: TextField(
            decoration:
                InputDecoration(labelText: 'Telefone', errorText: cpfError),
            controller: txtCelular,
            inputFormatters: [celularMask],
            keyboardType: TextInputType.number,
            style:
                TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.w400),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Text(
                'Estudante UERGS ?',
                style: new TextStyle(
                  color: Colors.black54,
                  fontSize: 16.0,
                ),
              ),
              new Radio(
                value: true,
                groupValue: this.checkIndUergs,
                onChanged: (newValue) {
                  this.checkIndUergs = newValue;
                  setState(() {});
                },
              ),
              new Text(
                'Sim',
                style: new TextStyle(color: Colors.black54, fontSize: 16.0),
              ),
              new Radio(
                value: false,
                groupValue: this.checkIndUergs,
                onChanged: (newValue) {
                  this.checkIndUergs = newValue;
                  setState(() {});
                },
              ),
              new Text(
                'Não',
                style: new TextStyle(
                  color: Colors.black54,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
        camposIndUergs(),
        dropDown(context),
        juizCheckCox(),
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Text(
                'Necessidade Especial?',
                style: new TextStyle(
                  color: Colors.black54,
                  fontSize: 16.0,
                ),
              ),
              new Radio(
                value: true,
                groupValue: this.checkEhNecessitado,
                onChanged: (newValue) {
                  this.checkEhNecessitado = newValue;
                  setState(() {});
                },
              ),
              new Text(
                'Sim',
                style: new TextStyle(color: Colors.black54, fontSize: 16.0),
              ),
              new Radio(
                value: false,
                groupValue: this.checkEhNecessitado,
                onChanged: (newValue) {
                  this.checkEhNecessitado = newValue;
                  setState(() {});
                },
              ),
              new Text(
                'Não',
                style: new TextStyle(
                  color: Colors.black54,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Container(
            width: 140,
            child: RaisedButton(
              child: Text('Atualizar Dados'),
              onPressed: () {
                Estudante estudante = new Estudante();
                estudante.nome = txtNome.text;
                estudante.cpf = userJuergs.cpf;
                if (checkIndUergs) {
                  estudante.campoUergs = txtInstituicao.text;
                  estudante.instituicao = "Uergs";
                } else {
                  estudante.campoUergs = "";
                  estudante.instituicao = txtInstituicao.text;
                }
                if (txtCelular.text.isNotEmpty) {
                  estudante.celular = txtCelular.text;
                }
                estudante.email = txtEmail.text;
                estudante.indNecessidade = checkEhNecessitado.toString();
                estudante.indUergs = checkIndUergs.toString();
                estudante.tipoParticipante = comboTipoParticipante;
                this.atualizar(estudante, context);
              },
            ),
          ),
        ),
      ],
    );
  }
}
