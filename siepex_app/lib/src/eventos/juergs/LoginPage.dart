import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:siepex/models/serializeJuergs.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'package:siepex/src/config.dart';
import 'package:siepex/src/eventos/juergs/models/equipe.dart';
import 'package:siepex/src/eventos/juergs/models/handledata.dart';

class LoginJuergs extends StatefulWidget {
  @override
  _LoginJuergsState createState() => _LoginJuergsState();
}

class _LoginJuergsState extends State<LoginJuergs> {
  TextEditingController cpfController = TextEditingController();

  var maskFormatter = new MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
  var _errorText = null;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 10,
          title: Text('Login'),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      'assets/img/arte_uergs/Background_App_Uergs.png'),
                  fit: BoxFit.cover)),
          child: Center(
            child: _isLoading ? CircularProgressIndicator() : corpo(context),
          ),
        ));
  }

  /*
    Fazer a verificação aqui e Caso esteja tudo certo, logar no usuario.
  */
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

  logar(BuildContext context, String cpf) async {
      try {
        setState(() {
          _isLoading = true;
        });
        var resposta = jsonDecode(
            (await http.put(baseUrl + 'obtemParticipante/', body: {'cpf': cpf}))
                .body);
        if (resposta['status'] != null) {
          if (resposta['status'] == 'ok') {
            Estudante estudante = new Estudante.fromJson(resposta['data']);
            userJuergs = estudante;// Loga usuario
            userJuergs.minhasEquipes =
                await Equipe.getMyEquipes(userJuergs.cpf);
            setState(() {
              _isLoading = false;
            });
            Navigator.popAndPushNamed(context, 'inicioJuergs');
          } else if (resposta['status'] == 'nao_achou') {
            setState(() {
              _isLoading = false;
            });
            Alert(
                    context: context,
                    title: "Erro",
                    desc: "Participante não cadastrado")
                .show();
          }
        }
      } catch (e) {
        print(e);
        Alert(context: context, title: "Erro", desc: "Falha no Login").show();
        setState(() {
          _isLoading = false;
        });
      }
  }

  Widget corpo(BuildContext context) {
    return Container(
      height: 250,
      width: 300,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: Color.fromRGBO(0xD8, 0xD8, 0xD8, 1),
      ),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 45),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'CPF',
                labelStyle:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                errorText: _errorText,
              ),
              inputFormatters: [maskFormatter],
              controller: cpfController,
              keyboardType: TextInputType.number,
              style: TextStyle(
                  color: Colors.lightBlue, fontWeight: FontWeight.w300),
            ),
          ),
          Container(
            height: 45,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(0, 81, 198, 1),
                    Color.fromRGBO(0, 75, 183, 1)
                  ]),
            ),
            child: FlatButton(
                onPressed: () => logar(context, maskFormatter.getUnmaskedText()),
                child: Align(
                  child: Text(
                    "Entrar",
                    style: TextStyle(color: Colors.white),
                  ),
                )),
          ),
          Expanded(
            flex: 1,
            child: FlatButton(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  Navigator.pushNamed(context, 'cadastraParticipante');
                },
                child: Text(
                  "Não é cadastrado?",
                  style: TextStyle(color: Color.fromRGBO(0, 60, 150, 1)),
                )),
          ),
        ],
      ),
    );
  }
}
