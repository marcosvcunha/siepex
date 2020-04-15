import 'package:flutter/material.dart';
import 'package:siepex/src/areaParticipante/homeParticipante.dart';
import 'package:siepex/src/inicio/itemButton.dart';
import 'package:siepex/mdi.dart';
import './Widgets/Drawer.dart';

class InicioJuergs extends StatelessWidget {
  final Widget child;
  InicioJuergs({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return corpo(context);
  }

Widget corpo(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 10,
          title: Text('Inicio'),
        ),
        drawer: JuergsDrawer(),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        'assets/img/arte_uergs/Background_App_Uergs.png'),
                    fit: BoxFit.fill)),
            child: ListView(
              children: <Widget>[
                Container(
                  height: 200,
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  width: double.infinity,
                  child: Image.asset(
                      'assets/img/arte_uergs/Logo_Juergs_original.png'),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                ),
                Row(
                  children: <Widget>[
                    itemButton(
                        new GridItem(
                            'Tabelas de Jogos', 'defaultPage', Icons.calendar_today),
                        context,
                        expanded: false),
                    itemButton(
                        new GridItem('Sobre o Juergs', 'juergsSobre', Icons.info),
                        context,
                        expanded: false),
                    itemButton(
                        new GridItem(
                          'Avisos',
                          'defaultPage',
                          Icons.warning,
                        ),
                        context,
                        expanded: false)
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                ),
                Row(
                  children: <Widget>[
                    itemButton(
                        new GridItem('Hoteis', 'hoteisJuergs', Icons.map), context,
                        expanded: false),
                    itemButton(
                        new GridItem(
                            'Restaurantes', 'restaurantesJuergs', Icons.fastfood),
                        context,
                        expanded: false),
                    itemButton(
                        new GridItem(
                            'Informações úteis', 'defaultPage', Icons.new_releases),
                        context,
                        expanded: false)
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                ),
                Row(
                  children: <Widget>[
                    itemButton(
                        new GridItem('Comissão Organizadora', 'defaultPage',
                            Icons.business_center),
                        context,
                        expanded: false),
                    itemButton(
                        new GridItem('Modalidades', 'modalidadesJuergs',
                            Icons.assignment_ind),
                        context,
                        expanded: false),
                    itemButton(
                        new GridItem(
                            'Mapa do evento', 'defaultPage', Mdi.map_marker),
                        context,
                        expanded: false)
                  ],
                ),
              ],
            )));
  }

}