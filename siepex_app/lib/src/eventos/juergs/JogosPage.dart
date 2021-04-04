import 'package:flutter/material.dart';
import 'package:siepex/src/eventos/juergs/models/serializeJuergs.dart';
import 'package:siepex/src/eventos/juergs/Widgets/CardJogo.dart';
import 'package:siepex/src/eventos/juergs/models/jogo.dart';

class JogosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F0F0),
      appBar: AppBar(
        title: Text('Meus Jogos'),
      ),
      body: FutureBuilder(
        future: Jogo.pegarJogosUser(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasData) {
              List<Jogo> jogos = snapshot.data;
              if (jogos.length > 0) {
                return ListView.builder(
                    itemCount: jogos.length,
                    padding: EdgeInsets.only(top: 12, left: 12, right: 12),
                    itemBuilder: (context, index) {
                      return CardJogo(jogo: jogos[index]);
                    });
              }
            }
            return Center(
              child: Text(
                'Você ainda não tem nenhum jogo marcado. Junte-se a uma equipe ou crie uma e aguarde a criação dos jogos.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            );
          }
        },
      ),
    );
  }
}
