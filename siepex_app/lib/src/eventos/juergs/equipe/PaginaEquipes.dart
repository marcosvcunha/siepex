import 'package:flutter/material.dart';
import 'package:siepex/models/modalidade.dart';
import 'package:siepex/models/serializeJuergs.dart';
import 'package:siepex/src/eventos/juergs/equipe/PaginaEquipe.dart';
import 'package:siepex/src/eventos/juergs/Widgets/participantesdialog.dart';
import 'package:siepex/src/eventos/juergs/Widgets/textinputdialog.dart';
import 'package:siepex/src/eventos/juergs/models/handledata.dart';
import '../models/equipe.dart';
import 'package:provider/provider.dart';
import './EquipeCard.dart';
import './RusticaCard.dart';

class PaginaEquipes extends StatefulWidget {
  final Widget child;
  final Modalidade modalidade;
  PaginaEquipes({Key key, this.child, this.modalidade}) : super(key: key);

  @override
  _PaginaEquipesState createState() => _PaginaEquipesState();
}

class _PaginaEquipesState extends State<PaginaEquipes> {
  bool isActive = true;

  Future<bool> _doPop() async {
    Navigator.pop(context, (){
       setState((){});
     });
    return false;
  }
  @override
  Widget build(BuildContext context) {
    isActive = widget.modalidade.nome == 'Rústica'
        ? true
        : widget.modalidade.dataLimite.isAfter(
            DateTime.now()); // Vê se a data limite de inscrição já passou.
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
                          return ChangeNotifierProvider(
                            create: (_) => equipesList[index],
                            child: _equipeCard(equipesList[index]),
                          );
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
            await HandleData().criarEquipe(
                context, widget.modalidade, userJuergs.nome, isActive);
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
  Widget _equipeCard(Equipe equipe) {
    if (widget.modalidade.nome != 'Rústica') {
      return EquipeCard(isActive: isActive,);
    } else {
      return RusticaCard();
    }
  }

}
