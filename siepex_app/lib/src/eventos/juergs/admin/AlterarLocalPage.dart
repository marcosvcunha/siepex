

import 'package:flutter/material.dart';
import 'package:siepex/src/eventos/juergs/Widgets/CardJogo.dart';
import 'package:siepex/src/eventos/juergs/Widgets/confirmDialog.dart';
import 'package:siepex/src/eventos/juergs/Widgets/errorDialog.dart';
import 'package:siepex/src/eventos/juergs/Widgets/loading.dart';
import 'package:siepex/src/eventos/juergs/Widgets/textinputdialog.dart';
import 'package:siepex/src/eventos/juergs/equipe/PaginaEquipe.dart';
import 'package:siepex/src/eventos/juergs/models/jogo.dart';
import 'package:siepex/utils/utils.dart';

class AlterarLocalPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alterar Local'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder(
          future: Jogo.pegarJogosPorModalidade(1),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }else{
              List<Jogo> jogos = snapshot.data;
              return ListView(
                children: [
                  SizedBox(height: 16,),
                  Text('Clique no jogo que deseja alterar o local:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  SizedBox(height: 16,),
                  Column(
                    children: List<Widget>.generate(
                  jogos.length,
                  (index){
                    ValueNotifier value = ValueNotifier(true); // GAMBIARRA : só serve pra atualizar o estado do widget
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () async {
                        print('APERTOU!');
                        // pushto(context, );
                        String novoLocal = await textInputDialog(context, 'Digite o local que será realizado o jogo:', 'Local');
                        if(novoLocal != null){
                          // Confirmar
                          bool confirm = await confirmDialogWithReturn(context, 'Atenção', 'Tem certeza que deseja mudar o local do jogo para "$novoLocal"?');
                          if(confirm){
                            // Atualiza no banco
                            Loading.neverSatisfied(context, true);

                            bool result = await jogos[index].atualizaLocalJogo(context, novoLocal);
                            if(result) jogos[index].local = novoLocal;
                            else errorDialog(context, 'Atenção', 'Ocorreu um erro desconhecido');
                            value.value = !value.value;
                            Loading.neverSatisfied(context, false);

                          }
                        }
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