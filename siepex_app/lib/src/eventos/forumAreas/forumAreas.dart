import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForumPage extends StatelessWidget {
  final Widget child;

  ForumPage({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Sobre o Fórum de Áreas'),
        ),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        'assets/img/arte_uergs/Background_App_Siepex.png'),
                    fit: BoxFit.fill)),
            child: ListView(
              children: <Widget>[
                AnnotatedRegion<SystemUiOverlayStyle>(
                    value: SystemUiOverlayStyle.dark,
                    child: ListTile(
                        title: Text(
                      "O que é o Fórum de Áreas:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ))),
                ListTile(
                    title: Text.rich(TextSpan(
                        text:
                            """   O evento anual que reúne professores, estudantes e funcionários da Universidade para a avaliação e o planejamento das atividades integradas que envolvem ensino, pesquisa e extensão, por área de conhecimento."""))),

              ],
            )));
  }
}
