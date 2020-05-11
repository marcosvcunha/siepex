import 'package:flutter/material.dart';
import 'package:siepex/src/eventos/juergs/PaginaEquipes.dart';
import 'package:siepex/src/eventos/juergs/Widgets/participantesdialog.dart';
import 'package:siepex/src/eventos/juergs/models/equipe.dart';
import 'package:siepex/src/eventos/juergs/models/handledata.dart';

class EquipeCard extends StatelessWidget {
  final Equipe equipe;
  final bool temEquipe;
  final bool isActive;
  EquipeCard({@required this.equipe, @required this.temEquipe, @required this.isActive});
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
                          color: temEquipe == true ? Colors.grey[600] : Colors.green[600],
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: SizedBox.expand(
                          child: FlatButton(
                            
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            //disabledTextColor: Colors.black,
                            onPressed: () async {
                              await HandleData().entrarEquipe(context, equipe.id, isActive);
                              print("Aqui");
                              //_notifier.reloadEquipes();
                            },
                            child: Center(
                                child: Text(
                              temEquipe ? 'Já Possui Equipe' : 'Entrar',
                              textAlign: TextAlign.center,
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
                            participantesDialog(context, equipe.participantesNomes);
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
