import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:siepex/src/inicio/itemButton.dart';

class ParticipanteJuergs extends StatelessWidget {
  final Widget child;
  ParticipanteJuergs({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return corpo(context);
  }

  Widget corpo(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: new Text(
            'Área do Participante',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      'assets/img/arte_uergs/Background_App_Uergs_teste.png'),
                  fit: BoxFit.fill)),
                              child: ListView(
              children: <Widget>[
                
                Padding(
                  padding: EdgeInsets.all(15),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    itemButtonPersonalizado(
                        new GridItem('Cadastrar Participante', 'cadastraParticipante', Icons.account_circle),
                        context,
                        expanded: false),
                  ],
                ),
                Row(children: <Widget>[
                  
                ],),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    itemButtonPersonalizado(
                        new GridItem('Cadastrar Equipe', 'defaultPage', Icons.account_circle),
                        context,
                        expanded: false),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                ),                
              ],
            )
        ));
  }
}
