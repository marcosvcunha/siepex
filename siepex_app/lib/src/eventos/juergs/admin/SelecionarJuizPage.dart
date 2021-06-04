

import 'package:flutter/material.dart';
import 'package:siepex/src/eventos/juergs/Widgets/CardJogo.dart';
import 'package:siepex/src/eventos/juergs/Widgets/confirmDialog.dart';
import 'package:siepex/src/eventos/juergs/Widgets/errorDialog.dart';
import 'package:siepex/src/eventos/juergs/Widgets/loading.dart';
import 'package:siepex/src/eventos/juergs/Widgets/textinputdialog.dart';
import 'package:siepex/src/eventos/juergs/admin/ListaJuizesPage.dart';
// import 'package:siepex/src/eventos/juergs/equipe/PaginaEquipe.dart';
import 'package:siepex/src/eventos/juergs/models/jogo.dart';
import 'package:siepex/src/eventos/juergs/models/serializeJuergs.dart';
import 'package:siepex/utils/utils.dart';
// import 'package:siepex/utils/utils.dart';

class SelecionarJuizPage extends StatelessWidget {
  final int modalidadeId;

  SelecionarJuizPage(this.modalidadeId);

  Future<List> pegarData() async {
    var result1 = Estudante.pegarJuizes();
    var result2 = Jogo.pegarJogosPorModalidade(modalidadeId);
    return [await result1, await result2];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecionar Juiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder(
          future: pegarData(),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }else{
              List<Jogo> jogos = snapshot.data[1];
              List<Estudante> juizes = snapshot.data[0];
              return ListView(
                children: [
                  SizedBox(height: 16,),
                  Text('Selecione o jogo que deseja alterar o juiz:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  SizedBox(height: 16,),
                  Column(
                    children: List<Widget>.generate(
                  jogos.length,
                  (index){
                    ValueNotifier value = ValueNotifier(true); // GAMBIARRA : só serve pra atualizar o estado do widget
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () async {
                        Loading.neverSatisfied(context, true);
                        var juiz = await pushto(context, ListaJuizesPage(juizes: juizes,));
                        if(juiz != null){
                          bool result = await jogos[index].alterarJuiz(juiz);
                          if(result){
                            jogos[index].nome_juiz = juiz;
                            value.value = !value.value;
                          }else errorDialog(context, 'Atenção', 'Ocorreu um erro desconhecido');
                          Loading.neverSatisfied(context, false);
                        }
                        // if(novoLocal != null){
                        //   // Confirmar
                        //   bool confirm = await confirmDialogWithReturn(context, 'Atenção', 'Tem certeza que deseja mudar o local do jogo para "$novoLocal"?');
                        //   if(confirm){
                        //     // Atualiza no banco
                        //     Loading.neverSatisfied(context, true);

                        //     bool result = await jogos[index].atualizaLocalJogo(context, novoLocal);
                        //     if(result) jogos[index].local = novoLocal;
                        //     else errorDialog(context, 'Atenção', 'Ocorreu um erro desconhecido');
                        //     value.value = !value.value;
                        //     Loading.neverSatisfied(context, false);

                        //   }
                        // }
                      },
                      child: ValueListenableBuilder(
                        valueListenable: value,
                        builder: (context, newVal, child){
                          return CardJogo(jogo: jogos[index]);
                        },
                      ),
                    );
                  }),
                  ),
                ]
              );
            }
          }
        ),
      ),
    );
  }
}