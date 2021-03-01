import 'package:flutter/material.dart';
import 'package:siepex/models/modalidade.dart';
import 'package:siepex/src/eventos/juergs/models/handledata.dart';
import 'package:siepex/src/eventos/juergs/models/jogo.dart';
import './widgets.dart';
import 'package:provider/provider.dart';

class TabelaFinal extends StatelessWidget {
  Widget _text(String text) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 22, color: Colors.black, fontWeight: FontWeight.w400),
    );
  }

  List<Widget> buildFinal(List<Jogo> jogos) {
    return [
      Text(
        'Final',
        style: TextStyle(
            fontSize: 22, color: Colors.black, fontWeight: FontWeight.w400),
      ),
      jogoCard(jogos[0]),
      Text(
        '3º Lugar',
        style: TextStyle(
            fontSize: 22, color: Colors.black, fontWeight: FontWeight.w400),
      ),
      jogoCard(jogos[1]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Modalidade modalidade = Provider.of<Modalidade>(context);
    return FutureBuilder(
        future: Jogo.pegaJogoPorFase(context, modalidade, Modalidade.fasesMap['Final']),
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
            color: Colors.grey[400],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: buildFinal(retJogos),
            ),
          );
        });
  }
}
