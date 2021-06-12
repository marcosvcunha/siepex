import 'package:flutter/material.dart';
import 'package:siepex/src/eventos/juergs/models/serializeJuergs.dart';
import 'package:siepex/src/eventos/juergs/Widgets/EquipeMiniCard.dart';
import 'package:siepex/src/eventos/juergs/models/equipe.dart';

class MinhasEquipesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFF0F0F0),
      appBar: AppBar(
        title: Text('Minhas Equipes'),
      ),

      body: FutureBuilder(
        future: Equipe.getMyEquipes(userJuergs.cpf),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasData) {
              List<Equipe> equipes = snapshot.data;
              if (equipes.length > 0) {
                return ListView.builder(
                  itemCount: equipes.length,
                  padding: EdgeInsets.only(left: 12, right: 12, top: 12),
                  itemBuilder: (context, index){
                    return EquipeMiniCard(equipe: equipes[index]);
                  }
                );
              }
            }
            return Center(
              child: Text(
                'Você não participa de nenhuma equipe.',
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