import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultPage extends StatelessWidget {
  final Widget child;

  DefaultPage({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,        
          //title: Text('Jogos Universitários da Uergs - Juergs'),
          title: new Text('Em construção',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
        ),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        'assets/img/arte_uergs/Background_App_Uergs_teste.png'),
                    fit: BoxFit.fill)),
            child: ListView(
              children: <Widget>[
                AnnotatedRegion<SystemUiOverlayStyle>(
                    value: SystemUiOverlayStyle.dark,
                    child: ListTile(
                        title: Text(
                      "Em construção...",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ))),               
              ],
            )));
  }
}
