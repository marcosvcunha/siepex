import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:siepex/src/eventos/juergs/Widgets/participantesdialog.dart';
import 'package:siepex/src/eventos/juergs/models/equipe.dart';

class EquipeCard extends StatelessWidget {
  final Equipe equipe;
  EquipeCard({@required this.equipe});
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
            //color: Colors.grey[200],
            //color: Color(0xff45D5E6),
            borderRadius: BorderRadius.all(Radius.circular(8)),
            //gradient: LinearGradient(colors: [Color(0xFF34B8B7), Color(0xFF7dd0a2)])
            gradient:
                LinearGradient(colors: [Color(0xFF3498B7), Color(0xFF7db0a2)])),
        height: 130,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  equipe.nome,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w600),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Participantes: ${equipe.numeroParticipantes}/${equipe.maximoParticipantes}',
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green[600],
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: SizedBox.expand(
                          child: FlatButton(
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onPressed: () {},
                            child: Center(
                                child: Text(
                              'Entrar',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            )),
                          ),
                        ),
                        height: 40,
                        width: 120,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffFFE569),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: SizedBox.expand(
                            child: FlatButton(
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: () {
                            participantesDialog(context, ['']);
                          },
                            child: Text(
                              'Ver Participantes',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                        )),
                        height: 40,
                        width: 120,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
