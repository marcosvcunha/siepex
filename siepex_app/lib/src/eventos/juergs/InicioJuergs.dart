import 'package:flutter/material.dart';
import 'package:siepex/icons/my_flutter_app_icons.dart';
import 'package:siepex/models/modalidade.dart';
import 'package:siepex/src/areaParticipante/homeParticipante.dart';
import 'package:siepex/src/eventos/juergs/PaginaTabelas.dart';
import 'package:siepex/src/inicio/itemButton.dart';
import 'package:siepex/mdi.dart';
import '../../../icons/sport_icons.dart';
import './ModalidadesPage.dart';
import './Widgets/Drawer.dart';

class InicioJuergs extends StatelessWidget {
  final Widget child;
  InicioJuergs({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return corpo(context);
  }

  Widget corpo(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[400],
        appBar: AppBar(
          elevation: 10,
          title: Text('Inicio'),
        ),
        drawer: JuergsDrawer(),
        body: TabBarView(
          children: <Widget>[
            Container(child: Center(child: Text('Meus Jogos',style: TextStyle(color: Colors.black),))),
            ModalidadesPage(),
            PaginaTabelas(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            //color: Color(0xFF283474),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                spreadRadius: 3,
                blurRadius: 3,
                offset: Offset(0, 2)
              )
            ]
          ),
          height: 70,
          child: TabBar(     
            indicatorColor: Colors.yellow,     
            tabs: [
            Tab(
              icon: Icon(Sport.soccer_field_from_top_view, size: 40,),
              text: 'Meus Jogos',
            ),
            Tab(
              icon: Padding(
                padding: EdgeInsets.all(5),
                child: Icon(Sport.volleyball_silhouette, size: 30,), 
              ),
              text: 'Modalidades',
            ),
            Tab(
              icon: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(Icons.table_chart, size: 30,),
              ),
              text: 'Tabelas'),
          ]),
        ),
      ),
    );
  }
}
