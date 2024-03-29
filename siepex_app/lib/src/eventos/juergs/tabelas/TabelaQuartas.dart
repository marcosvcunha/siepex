import 'package:flutter/material.dart';
import 'package:siepex/src/eventos/juergs/models/modalidade.dart';
import 'package:siepex/src/eventos/juergs/Widgets/CardJogo.dart';
import 'package:siepex/src/eventos/juergs/models/handledata.dart';
import 'package:siepex/src/eventos/juergs/models/jogo.dart';
import './widgets.dart';
import 'package:provider/provider.dart';

class TabelaQuartas extends StatelessWidget {
  Widget _text(String text) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 22, color: Colors.black, fontWeight: FontWeight.w400),
    );
  }

  List<Widget> buildQuartas(List<Jogo> jogos) {
    return [
      _text('Quartas 1'),
      CardJogo(jogo: jogos[0],),      // jogoCard(jogos[0]),
      _text('Quartas 2'),
      CardJogo(jogo: jogos[1],),
      _text('Quartas 3'),
      CardJogo(jogo: jogos[2],),
      // jogoCard(jogos[2]),
      _text('Quartas 4'),
      CardJogo(jogo: jogos[3],),
      // jogoCard(jogos[3]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Modalidade modalidade = Provider.of<Modalidade>(context);
    return FutureBuilder(
        future: Jogo.pegaJogoPorFase(context, modalidade, Modalidade.fasesMap['Quartas de Final']),
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
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: double.infinity,
            width: double.infinity,
            color: Color(0xFFF5F5F5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: buildQuartas(retJogos),
            ),
          );
        });
  }
}
