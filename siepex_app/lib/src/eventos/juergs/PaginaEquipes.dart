import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:siepex/models/modalidade.dart';

class PaginaEquipes extends StatelessWidget {
  final Widget child;
  final Modalidade modalidade;

  PaginaEquipes({Key key, this.child, this.modalidade}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(modalidade.nome);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Equipes da modalidade: ' + modalidade.nome),
        ),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        'assets/img/arte_uergs/Background_App_Uergs.png'),
                    fit: BoxFit.fill)),
            child: ListView(
              children: <Widget>[
                AnnotatedRegion<SystemUiOverlayStyle>(
                    value: SystemUiOverlayStyle.dark,
                    child: ListTile(
                        title: Text(
                      "Alguma Coisa",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ))),
                ListTile(
                    title: Text.rich(TextSpan(
                        text:
                            """  informacoes? """))),

              ],
            )));
  }
}
