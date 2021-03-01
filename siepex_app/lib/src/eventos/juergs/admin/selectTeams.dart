import 'package:flutter/material.dart';
import 'package:siepex/models/modalidade.dart';
import 'package:provider/provider.dart';
import 'package:siepex/src/eventos/juergs/Widgets/confirmDialog.dart';
import 'package:siepex/src/eventos/juergs/admin/listaEquipes.dart';
import 'package:siepex/src/eventos/juergs/models/equipe.dart';
import '../Widgets/roundButton.dart';
import '../Widgets/loadingSnackbar.dart';

/*
  Nesta página o ADM seleciona os times que vão para a próxima fase.
  O layout da página depende de qual é a próxima fase.
*/

class SelectTeamsPage extends StatefulWidget {
  @override
  _SelectTeamsPageState createState() => _SelectTeamsPageState();
}

class _SelectTeamsPageState extends State<SelectTeamsPage> {
  // bool _isLoading = false;
  List<Equipe> equipesSelecionaveis;
  List<Equipe> equipesSelecionadas;
// //   List<String> equipesGrupoNome = List.generate(24, (index) {
//     return 'Selecione';
//   });

  Modalidade modalidade;

  bool allFilled() {
    for (Equipe equipe in equipesSelecionadas) {
      if (equipe.id == -2) return false;
    }
    return true;
  }

  Widget gruposSelection() {
    List<String> groups = new List<String>();

    int numGroups;
    int numTimes;

    if (modalidade.faseStr == 'Inscrição') {
    	// Vai para a fase de grupos
		groups = ['Grupo A', 'Grupo B', 'Grupo C', 'Grupo D', 'Grupo E', 'Grupo F', 'Grupo G', 'Grupo H'];
    	numGroups = 8;
    	numTimes = 3;
    } else if (modalidade.faseStr == 'Fase de Grupos') {
        // Vai para Quartas
		groups = ['Quartas 1', 'Quartas 2', 'Quartas 3', 'Quartas 4'];
		numGroups = 4;
		numTimes = 2;
    } else if (modalidade.faseStr == 'Quartas de Final') {
		// Vai para Semi
		groups = ['Semi 1', 'Semi 2'];
		numGroups = 2;
		numTimes = 2;
    } else if (modalidade.faseStr == 'Semi-Final') {
		// Vai para final
		groups = ['Final', '3º Lugar'];
		numGroups = 2;
		numTimes = 2;
	} else if (modalidade.faseStr == 'Final') {}
    // LISTA COM AS TABELAS
    
	equipesSelecionadas = List.generate(numGroups * numTimes, (index) {
    	return equipesSelecionaveis[index]; // TODO: mudar para null
  	});
	
	return ListView.builder(
        itemCount: numGroups + 1,
        itemBuilder: (context, index) {
          if (index < groups.length)
            return Column(
              children: <Widget>[
                tabelaGrupos(context, groups[index], index, numTimes),
                SizedBox(
                  height: 20,
                ),
              ],
            );
          else
            //  BOTÃO PARA CONFIMAR O ENVIO DOS TIMES
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: roundButton('Confirmar', Colors.blue, Icons.thumb_up,
                  () async {
                if (true) {
                  confirmDialog(
                      context, 'Finalizar', 'Confimar envio das equipes?',
                      () async {
                    Navigator.pop(context);
                    Scaffold.of(context).showSnackBar(loadingSnackbar());
                    // TODO: receber resposta e verificar se deu certo.
                    await modalidade.nextFase(context, equipesSelecionadas);
                    Scaffold.of(context).hideCurrentSnackBar();
                    Navigator.pop(context);
                  }, () => Navigator.pop(context));
                } else
                // TODO:: conferir se todas equipes foram selecionadas
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Preencha todas as equipes!',
                    ),
                  ));
              }),
            );
        });
  }

  Widget tabelaGrupos(
      BuildContext context, String nomeCard, int cardIndex, int numTimes) {
    List<Widget> rows = List.generate(numTimes, (index) {
      return grupoLinha(
          context, (index + 1).toString(), cardIndex * numTimes + index);
    });
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: <Widget>[
          Align(
              alignment: Alignment.center,
              child: Text(
                nomeCard,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              )),
          Divider(
            color: Colors.black,
            indent: 20,
            thickness: 0.8,
            endIndent: 20,
          ),
          Column(
            children: rows,
          ),
        ],
      ),
    );
  }

  Widget grupoLinha(BuildContext context, String time, int index) {
	Equipe equipe = equipesSelecionadas[index];
	ValueNotifier<String> nomeEquipe = ValueNotifier(equipe == null ? 'Selecionar' : equipe.nome);
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Time ' + time,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            Row(
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.deepOrange,
                      size: 22,
                    ),
                    onPressed: () async {
						List<Equipe> equipesNaoSelecionadas = List<Equipe>.from(equipesSelecionaveis);
						equipesNaoSelecionadas.removeWhere((element) => equipesSelecionadas.contains(element));
                      Equipe equipeSelecionada = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChangeNotifierProvider.value(
                                    value: modalidade,
                                    child: ListaEquipesPage(
                                        equipeId: time,
                                        equipesSelecionaveis: equipesNaoSelecionadas),
                                  )));
                    equipesSelecionadas[index] = equipeSelecionada;
					nomeEquipe.value = equipeSelecionada == null ? 'Selecionar' : equipeSelecionada.nome; 
                    // setState(() {});
                    }),
                ValueListenableBuilder(
					valueListenable: nomeEquipe,
                 	builder: (BuildContext context, String teamName, Widget child){

					  return Text(
                    teamName,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                    overflow: TextOverflow.ellipsis,
                  );
				  },
                ),
              ],
            )
          ],
        ),
      ),
      Divider(
        color: Colors.black,
        indent: 20,
        thickness: 0.8,
        endIndent: 20,
      ),
    ]);
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
              'Voltar',
              style: TextStyle(color: Colors.black),
            ),
            content: new Text(
              'Tem certeza que deseja retornar? As alterações serão perdidas.',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Sim'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('Nao'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: estão sendo feitas chamadas a API a cada equipe selecionada: corrigir.
    modalidade = Provider.of<Modalidade>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Selecione as Equipes'),
        ),
        body: FutureBuilder(
			future: Equipe.getEquipesPorFase(modalidade.id, modalidade.fase),
			builder: (context, snapshot) {
				if(snapshot.connectionState == ConnectionState.waiting){
					return Center(child: CircularProgressIndicator());
				}else{
					if(snapshot.hasData){
						equipesSelecionaveis = snapshot.data;
						return gruposSelection();
					}else{
						return Center(child: Text('Ocorreu um problema'));
					}
				}
			},
		),
      ),
    );
  }
}

