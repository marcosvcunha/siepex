import 'package:flutter/material.dart';
import 'package:siepex/src/eventos/juergs/Home/HomePage.dart';
import 'package:siepex/src/eventos/juergs/Home/PaginaTabelas.dart';
import '../../../../icons/sport_icons.dart';
import 'ModalidadesPage.dart';
import '../Widgets/Drawer.dart';

class InicioJuergs extends StatefulWidget {
  // final Widget child;

  InicioJuergs({Key key}) : super(key: key);

  @override
  _InicioJuergsState createState() => _InicioJuergsState();
}

class _InicioJuergsState extends State<InicioJuergs> with SingleTickerProviderStateMixin {
  
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return corpo(context);
  }

  Widget corpo(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCFCFC),
      appBar: AppBar(
        elevation: 10,
        title: Text('Juergs'),
      ),
      drawer: JuergsDrawer(),
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          HomePage(tabController: tabController,),
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
          controller: tabController,
          indicatorColor: Color(0xFF5B1DC0),
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
    );
  }
}
