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
  List<Jogo> jogos = [];
  // List<Jogo> jogos = [
  //   Jogo('Time Legal', 'Time Maneiro', 2, 1, false, 'Jogo 1'),
  //   Jogo('Time Show', 'Time de Bola', 2, 3, false, 'Jogo 2'),
  //   Jogo('Time Massa', 'Time Chato', 1, 0, false, 'Jogo 3'),
  //   Jogo('Time Bonito', 'Time Feio', 1, 1, false, 'Jogo 4'),
  // ];

  SnackBar snackBar = SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text(
                      'Você deve terminar de editar cada jogo antes de salvar!'));

  @override
  Widget build(BuildContext context) {
    HandleData _handleData = HandleData();
    Modalidade modalidade = Provider.of<Modalidade>(context);
    print(modalidade.nome);
    print(modalidade.faseStr);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () async {
          
          print('OI!!!');
          if (jogos.length > 0) {
            bool beeingEdited = false;
            for (Jogo jogo in jogos) {
              if (jogo.beeingEdited) beeingEdited = true;
            }
            if (beeingEdited) {
              print('AQUI!!!');
              // TODO:: Não tá mostrando snackbar
              Scaffold.of(context).showSnackBar(snackBar);
            } else {
              await _handleData.atualizaJogos(jogos);
            }
          }
        },
      ),
      appBar: AppBar(
        title: Text(
          'Lançar Resultados ' + modalidade.nome,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: FutureBuilder(
          future: _handleData.listarJogos(modalidade, modalidade.fase),
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
