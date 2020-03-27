import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:siepex/src/inicio/itemButton.dart';

class Estudante {
  final String nome;
  final String cpf;
  final String email;
  final String instituicao;
  final bool indUergs;

  Estudante(
    this.nome,
    this.cpf,
    this.email,
    this.instituicao,
    this.indUergs,
  );

  String toString() {
    return 'Produto{nome: $nome, quantidade: $cpf, valor: $email}';
  }
}

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

  bool indUergs = true;

  bool ehNecessitado = false;

  String tipoParticipante = "Jogador";

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
    if (this.indUergs) {
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
          value: tipoParticipante,
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.lightBlue),
          underline: Container(height: 2, color: Colors.lightBlue),
          onChanged: (String newValue) {
            setState(() {
              tipoParticipante = newValue;
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
                  groupValue: this.indUergs,
                  onChanged: (newValue) {
                    this.indUergs = newValue;
                    setState(() {});
                  },
                ),
                new Text(
                  'Sim',
                  style: new TextStyle(color: Colors.black54, fontSize: 16.0),
                ),
                new Radio(
                  value: false,
                  groupValue: this.indUergs,
                  onChanged: (newValue) {
                    this.indUergs = newValue;
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
                  groupValue: this.ehNecessitado,
                  onChanged: (newValue) {
                    this.ehNecessitado = newValue;
                    setState(() {});
                  },
                ),
                new Text(
                  'Sim',
                  style: new TextStyle(color: Colors.black54, fontSize: 16.0),
                ),
                new Radio(
                  value: false,
                  groupValue: this.ehNecessitado,
                  onChanged: (newValue) {
                    this.ehNecessitado = newValue;
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
                  final String nome = txtNome.text;
                  final String cpf = txtCpf.text;
                  final String email = txtEmail.text;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
