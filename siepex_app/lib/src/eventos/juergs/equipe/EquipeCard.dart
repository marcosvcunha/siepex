import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siepex/models/modalidade.dart';
import 'package:siepex/models/serializeJuergs.dart';
import 'package:siepex/src/eventos/juergs/equipe/PaginaEquipe.dart';
import 'package:siepex/src/eventos/juergs/models/equipe.dart';

class EquipeCard extends StatelessWidget {
  final bool isActive;
  EquipeCard({@required this.isActive});

  Widget body(BuildContext context, Equipe equipe, int index) {
    Modalidade modalidade = Provider.of<Modalidade>(context);
    bool temEquipe = userJuergs.temEquipe(equipe.nomeModalidade);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          gradient:
              LinearGradient(colors: [Color(0xFF3498B7), Color(0xFF7db0a2)]),
          boxShadow: [
            BoxShadow(
                blurRadius: 2,
                spreadRadius: 1,
                color: Colors.black54,
                offset: Offset(0, 1))
          ],
        ),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  equipe.nome,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w600),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Capitão: ' + equipe.nomeCapitao,
                      style: TextStyle(
                          color: Colors.blueGrey[900],
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Contato: ' + equipe.celCapitaoFormated,
                      style: TextStyle(
                          color: Colors.blueGrey[900],
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Participantes: ${equipe.numeroParticipantes}/${equipe.maximoParticipantes}',
                      style: TextStyle(
                          color: Colors.blueGrey[900],
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 2),
                    ajustaEquipe(equipe.index, equipe.idModalidade),
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
                          color:
                              temEquipe ? Colors.grey[600] : Colors.green[600],
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 1,
                                spreadRadius: 1,
                                color: Colors.black54,
                                offset: Offset(0, 1))
                          ],
                        ),
                        child: SizedBox.expand(
                          child: FlatButton(
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            //disabledTextColor: Colors.black,
                            onPressed: temEquipe
                                ? null
                                : () async {
                                    await equipe.entrarEquipe(
                                        context, isActive);
                                    modalidade.inscrito =
                                        userJuergs.temEquipe(modalidade.nome);
                                  },
                            child: Center(
                                child: Text(
                              temEquipe ? 'Já Possui Equipe' : 'Entrar',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: temEquipe
                                      ? Colors.blueGrey[800]
                                      : Colors.black87),
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
                          //color: Color(0xffFFE569),
                          //color: Color(0xff4071FE),
                          //color: Color(0xff1C61EA),
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 1,
                                spreadRadius: 1,
                                color: Colors.black54,
                                offset: Offset(0, 1))
                          ],
                        ),
                        child: SizedBox.expand(
                            child: FlatButton(
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MultiProvider(providers: [
                                        ChangeNotifierProvider.value(
                                          value: equipe,
                                        ),
                                        ChangeNotifierProvider.value(
                                            value: modalidade),
                                      ], child: PaginaEquipe()))),
                          child: Text(
                            'Mais Informações',
                            style: TextStyle(
                                color: Colors.black87,
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

  Text ajustaEquipe(int index, int idModalidade) {
    if (idModalidade == 1 || idModalidade == 3) {
      if (index > 15) {
        return Text(
          'Equipe: ' + (index + 1).toString() + '/16',
          style: TextStyle(
              color: Colors.red[900],
              fontSize: 16,
              fontWeight: FontWeight.w400),
        );
      } else {
        return Text(
          'Equipe: ' + (index + 1).toString() + '/16',
          style: TextStyle(
              color: Colors.blueGrey[900],
              fontSize: 16,
              fontWeight: FontWeight.w400),
        );
      }
    } else if (idModalidade == 2) {
      if (index > 11) {
        return Text(
          'Equipe: ' + (index + 1).toString() + '/12',
          style: TextStyle(
              color: Colors.red[900],
              fontSize: 16,
              fontWeight: FontWeight.w400),
        );
      } else {
        return Text(
          'Equipe: ' + (index + 1).toString() + '/12',
          style: TextStyle(
              color: Colors.blueGrey[900],
              fontSize: 16,
              fontWeight: FontWeight.w400),
        );
      }
    } else if (idModalidade == 4 || idModalidade == 5) {
      if (index > 7) {
        return Text(
          'Equipe: ' + (index + 1).toString() + '/8',
          style: TextStyle(
              color: Colors.red[900],
              fontSize: 16,
              fontWeight: FontWeight.w400),
        );
      }
    } else {
      return Text(
        'Equipe: ' + (index + 1).toString() + '/8',
        style: TextStyle(
            color: Colors.blueGrey[900],
            fontSize: 16,
            fontWeight: FontWeight.w400),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Equipe equipe = Provider.of<Equipe>(context);
    int index = equipe.index;
    return equipe.isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : body(context, equipe, index);
  }
}