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
  PaginaEquipes({Key key, this.child}) : super(key: key);

  @override
  _PaginaEquipesState createState() => _PaginaEquipesState();
}

class _PaginaEquipesState extends State<PaginaEquipes> {
  bool isActive = true;
  Modalidade modalidade;

  @override
  Widget build(BuildContext context) {
    print('PaginaEquipes Build');
    modalidade = Provider.of<Modalidade>(context);
    isActive = modalidade.nome == 'Rústica'
        ? true
        : modalidade.dataLimite.isAfter(
            DateTime.now()); // Vê se a data limite de inscrição já passou.
    return Scaffold(
        //appBar: titulo(),
        appBar: AppBar(
          centerTitle: true,
          title: Text(modalidade.nome),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      'assets/img/arte_uergs/Background_App_Uergs.png'),
                  fit: BoxFit.fill)),
          child: FutureBuilder(
              future: HandleData().getEquipes(modalidade.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    ),
                  );
                } else {
                  List<Equipe> equipesList = snapshot.data;
                  equipesList = equipesList.reversed.toList();
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
<<<<<<< HEAD
                          return ChangeNotifierProvider.value(
                            value: equipesList[index],
                            child: _equipeCard(equipesList[index]),
=======
                          equipesList[index].index = index;
                          return ChangeNotifierProvider(
                            create: (_) => equipesList[index],             
                            child: _equipeCard(),
>>>>>>> 915e80b286973b39d028ce65ddf778e34ff249c5
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
    if (modalidade.nome != 'Rústica') {
      return AppBar(
        centerTitle: true,
        title: Text(modalidade.nome),
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
          //modalidade.nome),
      );
    }
  }
*/
  Widget selecionaBotao() {
    if (modalidade.nome == 'Rústica') {
      return FlatButton(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          padding: EdgeInsets.all(8),
          onPressed: () async {
            await HandleData().criarEquipe(
                context, modalidade, userJuergs.nome, isActive);
            modalidade.inscrito = userJuergs.temEquipe(modalidade.nome);
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
                await textInputDialog(context, modalidade);
            await HandleData()
                .criarEquipe(context, modalidade, nomeEquipe, isActive);
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
  Widget _equipeCard() {
    if (modalidade.nome != 'Rústica') {
      return EquipeCard(isActive: isActive);
    } else {
      return RusticaCard();
    }
  }

}
