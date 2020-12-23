import 'package:flutter/material.dart';
// import 'package:siepex/icons/my_flutter_app_icons.dart';
// import 'package:siepex/models/modalidade.dart';
// import 'package:siepex/src/areaParticipante/homeParticipante.dart';
import 'package:siepex/src/eventos/juergs/PaginaTabelas.dart';
// import 'package:siepex/src/inicio/itemButton.dart';
// import 'package:siepex/mdi.dart';
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
        backgroundColor: Colors.grey[200],
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
          height: 60,
          child: TabBar(     
            indicatorColor: Colors.yellow,     
            tabs: [
            Tab(
              icon: Icon(Icons.home, size: 26,),
              text: 'Home',
            ),
            Tab(
              icon: Icon(Sport.volleyball_silhouette, size: 26,), 
              text: 'Competições',
            ),
            Tab(
              icon: Icon(Icons.table_chart, size: 26,),
              text: 'Tabelas'),
          ]),
        ),
      ),
    );
  }
}
