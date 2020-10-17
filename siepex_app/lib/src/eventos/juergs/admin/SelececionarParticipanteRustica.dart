
import 'package:flutter/material.dart';
import 'package:siepex/src/eventos/juergs/models/equipe.dart';

// TODO: Implementar página em que o ADM seleciona a posição e ai vai para página com lista de participantes.
class SelececionarPartRustica extends StatefulWidget {
  final List<Equipe> participantes;
  final int position; // Posição sendo selecionada
  
  SelececionarPartRustica({this.participantes, this.position});
  @override
  _SelececionarPartRusticaState createState() => _SelececionarPartRusticaState();
}

class _SelececionarPartRusticaState extends State<SelececionarPartRustica> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, -1);
        return false;
      },
          child: Scaffold(
        appBar: AppBar(title: Text('Lançar Resultados Rústica')),
        body: ListView.builder(
          itemCount: widget.participantes.length + 1,
          itemBuilder: (context, index){
            if(index == 0)
              return Padding(
                padding: const EdgeInsets.only(top: 12.0, left: 12),
                child: Text('Selecione na lista abaixo o participante que finalizou na posição ${widget.position}:',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),)
              );
            return ListTile(
              title: Text(widget.participantes[index - 1].nome),
              subtitle: Text(widget.participantes[index - 1].celCapitaoFormated),
              onTap: (){
                Navigator.pop(context, index);
              },
            );
          },
          ),
      ),
    );
  }
}