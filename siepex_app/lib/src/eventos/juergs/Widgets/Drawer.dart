import 'package:flutter/material.dart';
import 'package:siepex/models/serializeJuergs.dart';

class JuergsDrawer extends StatelessWidget {
  Widget juergsDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.blue,
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(0, 90, 160, 1),
                  Color.fromRGBO(0, 120, 190, 1)
                ])),
            height: 200,
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: CircleAvatar(
                    backgroundColor: Color(0xff2595A6),
                    radius: 40,
                    child: Text(userJuergs.nome[0].toUpperCase(),
                        style: TextStyle(fontSize: 24, color: Colors.black87)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    userJuergs.nome,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    userJuergs.email,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
          listItem(context, 'Meu Perfil', Icons.person, () => Navigator.popAndPushNamed(context, "perfilParticipante")),
          listItem(context, 'Regulamento', Icons.short_text, () => Navigator.popAndPushNamed(context, "regulamentoPage")),
          listItem(context, 'Hoteis', Icons.local_hotel, () => Navigator.popAndPushNamed(context, "hoteisJuergs")),
          listItem(context, 'Restaurantes', Icons.local_dining, () => Navigator.popAndPushNamed(context, "restaurantesJuergs")),
          listItem(context, 'Sobre o JUERGS', Icons.announcement, () => Navigator.popAndPushNamed(context, "juergsSobre")),
          listItem(context, 'Sair', Icons.exit_to_app, (){
            userJuergs.logout();
            Navigator.popUntil(context, ModalRoute.withName('inicio'));
            })
        ],
      ),
    );
  }

  Widget listItem(BuildContext context, String text, IconData icone, Function func) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.6, color: Colors.black),
        ),
      ),
      height: 50,
      child: ListTile(
        leading: Icon(icone),
        title: Text(
          text,
          style: TextStyle(
              color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        onTap: () {
          if (func != null){
            func();
          }
        },
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return juergsDrawer(context);
  }
}
