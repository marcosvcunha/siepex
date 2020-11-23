import 'package:flutter/material.dart';
import 'package:siepex/models/modalidade.dart';
import 'package:provider/provider.dart';
import 'package:siepex/src/eventos/juergs/Widgets/GameCard.dart';
import 'package:siepex/src/eventos/juergs/models/handledata.dart';
import 'package:siepex/src/eventos/juergs/models/jogo.dart';

class LancarResultadosPage extends StatefulWidget {
  // Página para lançar os resultados das Quartas, Semi ou Final.

  @override
  _LancarResultadosPageState createState() => _LancarResultadosPageState();
}

class _LancarResultadosPageState extends State<LancarResultadosPage> {
  List<Jogo> jogos = [
    Jogo('Time Legal', 'Time Maneiro', 2, 1, false, 'Jogo 1'),
    Jogo('Time Show', 'Time de Bola', 2, 3, false, 'Jogo 2'),
    Jogo('Time Massa', 'Time Chato', 1, 0, false, 'Jogo 3'),
    Jogo('Time Bonito', 'Time Feio', 1, 1, false, 'Jogo 4'),
  ];

  @override
  Widget build(BuildContext context) {
    HandleData _handleData = HandleData();
    Modalidade modalidade = Provider.of<Modalidade>(context);
    print(modalidade.nome);
    print(modalidade.faseStr);
    return Scaffold(
      appBar: AppBar(
        title: Text('Lançar Resultados ' + modalidade.nome,
         overflow: TextOverflow.ellipsis,),
      ),
      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index){
          return FutureBuilder(
            future: _handleData.listarJogos(modalidade, modalidade.fase),
            builder: (context, snapshot) {
              return Provider<Jogo>.value(
                value: jogos[index],
                child: GameCard(),
              );
            }
          );
        },
      ),
    );
  }
}
