import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:siepex/models/serializeJuergs.dart';
import 'package:siepex/src/config.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

class CadastraParticipante extends StatefulWidget {
  final Widget child;
  CadastraParticipante({Key key, this.child}) : super(key: key);

  @override
  _CadastraParticipanteState createState() => _CadastraParticipanteState();
}

class _CadastraParticipanteState extends State<CadastraParticipante> {
  @override
  Widget build(BuildContext context) {
    return corpo(context);
  }

  TextEditingController txtNome = TextEditingController();

  TextEditingController txtCpf = TextEditingController();

  TextEditingController txtEmail = TextEditingController();

  TextEditingController txtInstituicao = TextEditingController();

  bool checkIndUergs = true;

  bool checkEhNecessitado = false;

  String comboTipoParticipante = "Jogador";

  var controller = MaskedTextController(mask: '000.000.000-00');

  showAlertDialog1(BuildContext context) {
    // configura o button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // configura o  AlertDialog
    AlertDialog alerta = AlertDialog(
      title: Text(
        "Cadastro realizado com sucesso",
        style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.w300),
      ),
      content: Text(
        "Nome: " +
            this.txtNome.text +
            "\nCPF: " +
            this.txtCpf.text +
            "\nEmail: " +
            this.txtEmail.text,
        style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.w300),
      ),
      actions: [
        okButton,
      ],
    );
    // exibe o dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alerta;
      },
    );
  }

  Widget camposIndUergs() {
    if (this.checkIndUergs) {
      return Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: TextField(
          decoration: InputDecoration(labelText: 'Instituição'),
          controller: txtInstituicao,
          keyboardType: TextInputType.text,
          style:
              TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.w300),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: TextField(
          decoration: InputDecoration(labelText: 'Campos'),
          controller: txtInstituicao,
          keyboardType: TextInputType.text,
          style:
              TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.w300),
        ),
      );
    }
  }

  @override
  Widget dropDown(BuildContext context) {
    return Row(
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
        DropdownButton<String>(
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
          items: <String>['Jogador', 'Espectador', 'Juiz', 'Outro']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  cadastrar(Estudante estudante, BuildContext context) async {
    print("login");
    estudante.cpf = (estudante.cpf.replaceAll(".", "")).replaceAll("-", "");
    print(estudante.cpf);

    print(baseUrl + 'cadastroJuergs/$estudante' + estudante.toJson().toString());
    try {
      var resposta = jsonDecode(
          (await http.put(baseUrl + 'cadastroJuergs/', body: {'cpf' : estudante.cpf}))
              .body);
      if (resposta['erro'] != null) {
        Alert(
          context: context,
          type: AlertType.error,
          title: "Erro",
          desc: resposta['erro'],
          buttons: [
            DialogButton(
              child: Text(
                "Ok",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      } else {
      }
      // print(storage.getItem("user"));
    } catch (e) {
      print(e);
      Alert(context: context, title: "Erro", desc: "Falha no Cadastro").show();
    }
  }

  Widget corpo(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: new Text(
          'Cadastra Participante',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: TextField(
              decoration: InputDecoration(labelText: 'Nome'),
              controller: txtNome,
              keyboardType: TextInputType.text,
              style: TextStyle(
                  color: Colors.lightBlue, fontWeight: FontWeight.w300),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: TextField(
              decoration: InputDecoration(labelText: 'CPF'),
              controller: controller,
              keyboardType: TextInputType.number,
              style: TextStyle(
                  color: Colors.lightBlue, fontWeight: FontWeight.w300),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: TextField(
              decoration: InputDecoration(labelText: 'Email'),
              controller: txtEmail,
              keyboardType: TextInputType.text,
              style: TextStyle(
                  color: Colors.lightBlue, fontWeight: FontWeight.w300),
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
              width: 120,
              child: RaisedButton(
                child: Text('Cadastrar'),
                onPressed: () {
                  Estudante estudante = new Estudante();
                  estudante.nome = txtNome.text;
                  estudante.cpf = controller.text;
                  estudante.campoUergs = txtInstituicao.text;
                  estudante.email = txtEmail.text;
                  estudante.indNecessidade = checkEhNecessitado.toString();
                  estudante.indUergs = checkIndUergs.toString();
                  estudante.tipoParticipante = comboTipoParticipante;
                  this.cadastrar(estudante, context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
