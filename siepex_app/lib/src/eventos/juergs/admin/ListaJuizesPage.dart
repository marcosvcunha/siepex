import 'package:flutter/material.dart';
import 'package:siepex/src/eventos/juergs/models/serializeJuergs.dart';

class ListaJuizesPage extends StatelessWidget {
  final List<Estudante> juizes;

  ListaJuizesPage({@required this.juizes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecione o juiz'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
        children: [
          SizedBox(height: 16,),
          Text('Clique no juiz para o jogo selecionado:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          Column(
            children: List.generate(
              juizes.length,
              (index){
                return ListTile(
                  onTap: (){
                    Navigator.pop(context, juizes[index].nome);
                  },
                  title: Text(juizes[index].nome),
                  subtitle: Text(juizes[index].celularString),
                );
              }
            ),
          ),
        ]
      ),
      )
    );
  }
}