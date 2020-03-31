import 'dart:ui';

import 'package:flutter/material.dart';
import '../../../models/modalidade.dart';

List modalidades = [
  Modalidade(0, 'Ciclismo', 5, true),
  Modalidade(1, 'Natação', 10, false),
  Modalidade(2, 'Futebol', 22, true),
  Modalidade(3, 'Ping Pong', 6, false),
];

class ModalidesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Modalidades"),        
        ),
        body: ListView.builder(
          itemCount: 4,
          itemBuilder: (context, index){
            return modalidadesCard(modalidades[index]);
          }
          ),
    );
  }
}

Widget modalidadesCard(Modalidade modalidade){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromRGBO(0, 60, 125, 1),
            width: 2,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.blue,
        ),
        height: 100,
        //width: 300,
        child: FlatButton(
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(width: 4, color: Color.fromRGBO(0, 60, 125, 1))
                    ),
                  ),
                  height: 100,
                  width: 100,
                  //color:Colors.white,
                  child: modalidade.icon,
                ),
              ),
              Expanded(
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                        child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 8, 0, 0),
                        child: Text(modalidade.nome, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 6),
                        child: Text("Tamanho max. da equipe: ", 
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14, fontWeight: FontWeight.w400),),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text("Inscrito:"),
                          Checkbox(
                            activeColor: Colors.green,
                            value: modalidade.inscrito,
                            checkColor: Colors.white,
                            onChanged: (value){},),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          onPressed: (){},
        ),
      ),
    ),
  );
}