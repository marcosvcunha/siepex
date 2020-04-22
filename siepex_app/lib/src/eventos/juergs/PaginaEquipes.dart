import 'package:flutter/material.dart';
import 'package:siepex/models/modalidade.dart';
import 'package:siepex/models/serializeJuergs.dart';
import 'package:siepex/src/eventos/juergs/Widgets/equipeCard.dart';
import 'package:siepex/src/eventos/juergs/Widgets/participantesdialog.dart';
import 'package:siepex/src/eventos/juergs/Widgets/textinputdialog.dart';
import 'package:siepex/src/eventos/juergs/models/handledata.dart';
import 'package:siepex/src/eventos/juergs/notifier/equipesnotifier.dart';
import 'package:provider/provider.dart';
import 'models/equipe.dart';

class PaginaEquipes extends StatefulWidget {
  final Widget child;
  final Modalidade modalidade;
  PaginaEquipes({Key key, this.child, this.modalidade}) : super(key: key);

  @override
  _PaginaEquipesState createState() => _PaginaEquipesState();
}

class _PaginaEquipesState extends State<PaginaEquipes> {
  @override
  Widget build(BuildContext context) {
    bool temEquipe = userJuergs.temEquipe(widget.modalidade.nome);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.modalidade.nome),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    'assets/img/arte_uergs/Background_App_Uergs.png'),
                fit: BoxFit.fill)),
        child: FutureBuilder(
            future: HandleData().getEquipes(widget.modalidade.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blue,
                  ),
                );
              } else {
                List<Equipe> equipesList = snapshot.data;
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return _equipeCard(context, equipesList[index], temEquipe);
                      });
                } else {
                  return Center(
                    child: Text(
                      'Nenhuma equipe cadastrada.',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }
              }
            }),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(60))),
        height: 60,
        width: 80,
        child: SizedBox.expand(
          child: FlatButton(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () async {
                String nomeEquipe =
                    await textInputDialog(context, widget.modalidade);
                await HandleData()
                    .criarEquipe(context, widget.modalidade, nomeEquipe);
                setState(() {});
              },
              child: Center(
                child: Text(
                  'Criar Equipe',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              )),
        ),
      ),
    );
  }

  Widget _equipeCard(BuildContext context, Equipe equipe, bool temEquipe) {
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
                              await HandleData().entrarEquipe(context, equipe.id);
                              setState(() {});
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
