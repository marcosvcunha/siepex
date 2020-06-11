import 'package:flutter/material.dart';
import 'package:siepex/models/modalidade.dart';
import 'package:siepex/models/serializeJuergs.dart';
import 'package:siepex/src/eventos/juergs/Widgets/participantesdialog.dart';
import 'package:siepex/src/eventos/juergs/Widgets/textinputdialog.dart';
import 'package:siepex/src/eventos/juergs/models/handledata.dart';
import 'models/equipe.dart';

class PaginaEquipes extends StatefulWidget {
  final Widget child;
  final Modalidade modalidade;
  PaginaEquipes({Key key, this.child, this.modalidade}) : super(key: key);

  @override
  _PaginaEquipesState createState() => _PaginaEquipesState();
}

class _PaginaEquipesState extends State<PaginaEquipes> {
  bool isActive = true;
  @override
  Widget build(BuildContext context) {
    isActive = widget.modalidade.nome == 'Rústica' ? true 
      : widget.modalidade.dataLimite.isAfter(DateTime.now()); // Vê se a data limite de inscrição já passou.
    bool temEquipe = userJuergs.temEquipe(widget.modalidade.nome);
    return Scaffold(
      //appBar: titulo(),
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
                        return _equipeCard(
                            context, equipesList[index], temEquipe);
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
            //color: Theme.of(context).primaryColor,
            color: Colors.green[600],
            borderRadius: BorderRadius.all(Radius.circular(60))),
        height: 60,
        width: 80,
        child: SizedBox.expand(child: selecionaBotao()),
      ),
    );
  }

/* TODO: ARRUMAR DEPOIS PARA O TITULO PEGAR O NUMERO DE PARTICIPANTES INSCRITOS
  Widget titulo() {
    if (widget.modalidade.nome != 'Rústica') {
      return AppBar(
        centerTitle: true,
        title: Text(widget.modalidade.nome),
      );
    } else {
                var resposta =
          jsonDecode((await http.put(baseUrl + 'equipe/contaRustica',))
              .body);
            return AppBar(
        centerTitle: true,
        title: Text(
          'aaa'),
          //resposta.data.cont),
          //widget.modalidade.nome),
      );
    }
  }
*/
  Widget selecionaBotao() {
    if (widget.modalidade.nome == 'Rústica') {
      return FlatButton(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          padding: EdgeInsets.all(8),
          onPressed: () async {
            await HandleData()
                .criarEquipe(context, widget.modalidade, userJuergs.nome, isActive);
            setState(() {});
          },
          child: Center(
            child: Text(
              'Participar',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ));
    } else {
      return FlatButton(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () async {
            String nomeEquipe =
                await textInputDialog(context, widget.modalidade);
            await HandleData()
                .criarEquipe(context, widget.modalidade, nomeEquipe, isActive);
            setState(() {});
          },
          child: Center(
            child: Text(
              'Criar Equipe',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ));
    }
  }

  Widget _equipeCard(BuildContext context, Equipe equipe, bool temEquipe) {
    if (widget.modalidade.nome != 'Rústica') {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              gradient: LinearGradient(
                  colors: [Color(0xFF3498B7), Color(0xFF7db0a2)])),
          //height: 130,
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
                      Text('Capitão: ' + equipe.nomeCapitao, style: TextStyle(
                            color: Colors.blueGrey[900],
                            fontSize: 18,
                            fontWeight: FontWeight.w400),),
                      SizedBox(height: 2),
                      Text('Contato: ' + equipe.celCapitaoFormated, style: TextStyle(
                            color: Colors.blueGrey[900],
                            fontSize: 16,
                            fontWeight: FontWeight.w400),),
                      SizedBox(height: 2),
                      Text(
                        'Participantes: ${equipe.numeroParticipantes}/${equipe.maximoParticipantes}',
                        style: TextStyle(
                            color: Colors.blueGrey[900],
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Padding(
              //     padding: const EdgeInsets.only(left: 16.0),
              //     child: Text('Capitão: Marcos'),
              //   )),
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
                            color: temEquipe
                                ? Colors.grey[600]
                                : Colors.green[600],
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: SizedBox.expand(
                            child: FlatButton(
                              focusColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              //disabledTextColor: Colors.black,
                              onPressed: temEquipe ? null : () async {
                                await HandleData()
                                    .entrarEquipe(context, equipe.id, isActive);
                                setState(() {});
                              },
                              child: Center(
                                  child: Text( temEquipe ? 'Já Possui Equipe' : 'Entrar',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.w600, 
                                  color: temEquipe ? Colors.blueGrey[800] : Colors.black),
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
                              participantesDialog(
                                  context, equipe.participantesNomes, equipe.indexCapitao());
                            },
                            child: Text(
                              'Participantes',
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
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              gradient: LinearGradient(
                  colors: [Color(0xFF3498B7), Color(0xFF7db0a2)])),
          height: 50,
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
                        fontWeight: FontWeight.w600,),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
