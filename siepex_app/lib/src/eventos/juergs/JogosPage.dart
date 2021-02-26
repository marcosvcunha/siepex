import 'package:flutter/material.dart';
import 'package:siepex/models/serializeJuergs.dart';
import 'package:siepex/src/eventos/juergs/Widgets/CardJogo.dart';
import 'package:siepex/src/eventos/juergs/models/jogo.dart';

class JogosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0E0E0),
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
                return Padding(
                  padding: const EdgeInsets.only(top: 12.0, left: 12, right: 12),
                  child: ListView.builder(
                    itemCount: jogos.length,
                    itemBuilder: (context, index){
                      return CardJogo(jogo: jogos[index]);
                    }
                  ),
                );
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
