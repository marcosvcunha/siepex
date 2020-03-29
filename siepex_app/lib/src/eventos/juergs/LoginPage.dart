import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class LoginJuergs extends StatefulWidget {
  @override
  _LoginJuergsState createState() => _LoginJuergsState();
}

class _LoginJuergsState extends State<LoginJuergs> {
  TextEditingController cpfController = TextEditingController();

  var maskFormatter = new MaskTextInputFormatter(mask: '###.###.###-##', filter: { "#": RegExp(r'[0-9]') });
  var _errorText = null;

  @override
  Widget build(BuildContext context) {
    return corpo(context);
  }

  /*
    Fazer a verificação aqui e Caso esteja tudo certo, logar no usuario.
  */
  void cpfVerifier(){
    if(maskFormatter.getUnmaskedText().length < 11)
      _errorText = "Cpf invalido!";
    else{
      _errorText = null;
      Navigator.popAndPushNamed(context, 'inicioJuergs');
    }
      setState(() {
        
      });
  }

  Widget corpo(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 10,
          title: Text('Login'),
        ),
        //drawer: HomeParticipante(),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      'assets/img/arte_uergs/Background_App_Uergs.png'),
                  fit: BoxFit.cover)),
          child: Center(
            child: Container(
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
                    padding: const EdgeInsets.fromLTRB(30,30,30,45),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'CPF', 
                        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
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
                        onPressed: ()=>cpfVerifier(),
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
                        onPressed: (){
                          Navigator.pushNamed(context, 'cadastraParticipante');
                        },
                        child: Text(
                          "Não é cadastrado?",
                          style:
                              TextStyle(color: Color.fromRGBO(0, 60, 150, 1)),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
