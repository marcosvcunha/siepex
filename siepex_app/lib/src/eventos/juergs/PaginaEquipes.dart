import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaginaEquipes extends StatelessWidget {
  final Widget child;

  PaginaEquipes({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Equipe'),
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
