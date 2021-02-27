import 'package:flutter/material.dart';
import 'package:siepex/models/modalidade.dart';
import 'package:provider/provider.dart';
import 'package:siepex/src/eventos/juergs/Widgets/GameCard.dart';
import 'package:siepex/src/eventos/juergs/Widgets/confirmDialog.dart';
import 'package:siepex/src/eventos/juergs/Widgets/errorDialog.dart';
import 'package:siepex/src/eventos/juergs/models/handledata.dart';
import 'package:siepex/src/eventos/juergs/models/jogo.dart';

class LancarResultadosPage extends StatefulWidget {
  // Página para lançar os resultados das Quartas, Semi ou Final.

  @override
  _LancarResultadosPageState createState() => _LancarResultadosPageState();
}

class _LancarResultadosPageState extends State<LancarResultadosPage> {
  List<Jogo> jogos = [];
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    Modalidade modalidade = Provider.of<Modalidade>(context);
    return Scaffold(
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
            child: Icon(Icons.done),
            onPressed: () async {
              
              if (jogos.length > 0) {
                bool beeingEdited = false;
                for (Jogo jogo in jogos) {
                  if (jogo.beeingEdited) beeingEdited = true;
                }
                if (beeingEdited) {
                  errorDialog(context, 'Desculpe!', 'Antes de atualizar os jogos você deve terminar de editar cada um.');
                } else {
                  bool confirm = await confirmDialogWithReturn(context, 'Atenção!', 'Deseja mesmo atualizar os resultados?');
                  if(confirm){
                    final snackbar = SnackBar(content: Text('Carregando'));
                    Scaffold.of(context).showSnackBar(snackbar);
                    await Jogo.atualizaJogos(jogos, context);
                    Scaffold.of(context).hideCurrentSnackBar();
                  }
                }
              }
            },
          );
        }
      ),
      appBar: AppBar(
        title: Text(
          'Lançar Resultados ' + modalidade.nome,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: _loading ? Center(child: CircularProgressIndicator(),) :
      FutureBuilder(
          future: Jogo.pegaJogoPorFase(context, modalidade),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (!snapshot.hasData) {
                return Center(
                  child: Text(
                    'Desculpe, um erro ocorreu!',
                    style: TextStyle(fontSize: 22),
                  ),
                );
              } else {
                jogos = snapshot.data;
                return ListView.builder(
                    itemCount: jogos.length,
                    itemBuilder: (context, index) {
                      jogos[index].nome = 'Jogo ' + (index + 1).toString();
                      return Provider<Jogo>.value(
                        value: jogos[index],
                        child: GameCard(),
                      );
                    });
              }
            }
          }),
    );
  }
}
