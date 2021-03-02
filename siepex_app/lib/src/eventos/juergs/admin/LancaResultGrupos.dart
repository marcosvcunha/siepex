import 'package:flutter/material.dart';
import 'package:siepex/models/modalidade.dart';
import 'package:provider/provider.dart';
import 'package:siepex/src/eventos/juergs/Widgets/GameCard.dart';
// import 'package:siepex/src/eventos/juergs/admin/TabelasGruposAdmin.dart';
import 'package:siepex/src/eventos/juergs/models/jogo.dart';
import '../Widgets/errorDialog.dart';
import '../Widgets/confirmDialog.dart';

/*
Seleciona o resultado das partidas para alterar
*/

class LancaResultadosGruposPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Modalidade modalidade = Provider.of<Modalidade>(context);
    List<String> grupos;
    int numJogos;
      print('Aqui');
    if(modalidade.formatoCompeticao == 32){
      grupos = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
      numJogos = 6;
    }else if(modalidade.formatoCompeticao == 24){
      grupos = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
      numJogos = 3;
    }else if(modalidade.formatoCompeticao == 16){
      grupos = ['A', 'B', 'C', 'D'];
      numJogos = 6;
    }else if(modalidade.formatoCompeticao== 12){
      grupos = ['A', 'B', 'C', 'D'];
      numJogos = 3;
    }


    return FutureBuilder(
      future: Jogo.pegaJogoPorFase(context, modalidade, modalidade.fase),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text(modalidade.nome),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.hasData) {
            List<Jogo> jogos = snapshot.data;
            if (jogos.length > 0) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(modalidade.nome),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(
                        icon: Icon(Icons.done),
                        onPressed: () async {
                          if (jogos.length > 0) {
                            bool beeingEdited = false;
                            for (Jogo jogo in jogos) {
                              if (jogo.beeingEdited) beeingEdited = true;
                            }
                            if (beeingEdited) {
                              errorDialog(context, 'Desculpe!',
                                  'Antes de atualizar os jogos você deve terminar de editar cada um.');
                            } else {
                              bool confirm = await confirmDialogWithReturn(
                                  context,
                                  'Atenção!',
                                  'Deseja mesmo atualizar os resultados?');
                              if (confirm) {
                                // final snackbar =
                                //     SnackBar(content: Text('Carregando'));
                                // Scaffold.of(context).showSnackBar(snackbar);
                                await Jogo.atualizaJogos(jogos, context);
                                // Scaffold.of(context).hideCurrentSnackBar();
                                Navigator.pop(context);
                              }
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
                body: ListView.builder(
                  itemCount: grupos.length,
                  itemBuilder: (context, index) {
                    List<Widget> cardJogos = List.generate(numJogos, (indexJogo){
                      return Provider.value(
                            value: jogos[index * numJogos + indexJogo],
                            child: GameCard(
                              nomeJogo: 'Jogo ' + (indexJogo + 1).toString(),
                            ),
                          );
                    });
                    return Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Grupo ' + grupos[index],
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                        ] + cardJogos + [SizedBox(height: 32)],
                      ),
                    );
                  },
                ),
              );
            }
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(modalidade.nome),
            ),
            body: Center(
              child: Text('Ocorreu um problema!'),
            ),
          );
        }
      },
    );
  }
}
