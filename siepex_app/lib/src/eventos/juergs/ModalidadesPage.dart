import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:siepex/models/serializeJuergs.dart';
import 'package:siepex/src/eventos/juergs/PaginaEquipes.dart';
import 'package:siepex/src/eventos/juergs/models/handledata.dart';
import '../../../models/modalidade.dart';

class ModalidadesPage extends StatelessWidget {
  final HandleData _handleData = HandleData();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
          future: _handleData.getModalidades(),
          builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Mostra Isso quando os dados estão sendo carregados.
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            // Se a função Future retornar alguma coisa, mostra aqui.
            if (snapshot.hasData) {
              List<Modalidade> modalidades = snapshot.data;
              return ListView.builder(
                  itemCount: modalidades.length,
                  itemBuilder: (context, index) {
                    return modalidadesCard(context, modalidades[index], userJuergs.temEquipe(modalidades[index].nome));
                  });
            } else {
              // Se nenhuma modalidade for cadastrada.
              return Center(
                child: Text('Nenhuma Modalidade Cadastrada.'),
              );
            }
          }
        });
  }
}

Widget modalidadesCard(BuildContext context, Modalidade modalidade, bool temEquipe) {
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
        height: 125,
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
                        right: BorderSide(
                            width: 4, color: Color.fromRGBO(0, 60, 125, 1))),
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
                        child: Text(modalidade.nome,
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 6),
                        child: Text(
                          "Tamanho max. da equipe: " + modalidade.maxParticipantes.toString(),
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 6),
                        child: Text(
                          "Fim das inscrições: " + modalidade.dataLimiteString,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text("Inscrito:"),
                          Checkbox(
                            activeColor: Colors.green,
                            value: temEquipe,
                            checkColor: Colors.white,
                            onChanged: (value) {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PaginaEquipes(modalidade: modalidade,)));
          },
        ),
      ),
    ),
  );
}
