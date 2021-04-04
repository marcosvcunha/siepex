import 'package:flutter/material.dart';
import 'package:siepex/src/eventos/juergs/models/modalidade.dart';
import 'package:siepex/src/eventos/juergs/Widgets/CardJogo.dart';
import 'package:siepex/src/eventos/juergs/models/handledata.dart';
import 'package:siepex/src/eventos/juergs/models/jogo.dart';
import './widgets.dart';
import 'package:provider/provider.dart';

class TabelaSemi extends StatelessWidget {
  Widget _text(String text) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 22, color: Colors.black, fontWeight: FontWeight.w400),
    );
  }

  List<Widget> buildSemi(List<Jogo> jogos) {
    return [
      Text(
        'Semi 1',
        style: TextStyle(
            fontSize: 22, color: Colors.black, fontWeight: FontWeight.w400),
      ),
      // jogoCard(jogos[0]),
      Card(child: CardJogo(jogo: jogos[0],), elevation: 3,),
      Text(
        'Semi 2',
        style: TextStyle(
            fontSize: 22, color: Colors.black, fontWeight: FontWeight.w400),
      ),
      Card(child: CardJogo(jogo: jogos[1],), elevation: 3,),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Modalidade modalidade = Provider.of<Modalidade>(context);
    return FutureBuilder(
        future: Jogo.pegaJogoPorFase(context, modalidade, Modalidade.fasesMap['Semi-Final']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Jogo> retJogos = snapshot.data;
          if (retJogos.length == 0) {
            return MaterialApp(
              home: Scaffold(
                appBar: AppBar(
                  title: Text("Nada para mostrar"),
                ),
              ),
            );
          }
          return Container(
            height: double.infinity,
            width: double.infinity,
            color: Color(0xFFF5F5F5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: buildSemi(retJogos),
            ),
          );
        });
  }
}
