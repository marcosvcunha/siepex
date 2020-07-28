import 'package:flutter/material.dart';
// import 'package:siepex/src/areaParticipante/homeParticipante.dart';
import 'package:siepex/src/inicio/itemButton.dart';

class InicioPage extends StatelessWidget {
  final Widget child;
  InicioPage({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return selecionaEvento(context);
  }

  Widget selecionaEvento(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 10,
          centerTitle: true,
          title: Text('Eventos UERGS'),
        ),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(                       
                        'assets/img/arte_uergs/Background_App_Uergs.png'),
                    fit: BoxFit.cover)),
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                  width: double.infinity,
                  child: Image.asset(
                      'assets/img/arte_uergs/UergsBrancoHorizontal.png'),
                ),
                Padding(                 
                  padding: EdgeInsets.all(15),
                ),
                Column(
                  children: <Widget>[      
                    itemButtonPersonalizado(new GridItem('Siepex', 'inicioSiepex', Icons.event_note), context,
                        expanded: false),
                    itemButtonPersonalizado(new GridItem('Juergs', 'alternatePage', Icons.event_note), context,
                        expanded: false),
                    itemButtonPersonalizado(new GridItem('Fórum de Áreas', 'forumAreas', Icons.event_note), context,
                        expanded: false)
                  ],
                ),
              ],
            )));
  }

  
}
