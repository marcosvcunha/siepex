
import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:siepex/src/eventos/juergs/models/ParticipanteRustica.dart';
import 'package:siepex/src/eventos/juergs/models/handledata.dart';

class TabelaRustica extends StatelessWidget {
  List<TableRow> tableRows(List<ParticipanteRustica> participantes) {
    participantes.sort((a, b){
      if(a.temPos && b.temPos)
        return a.posicao.compareTo(b.posicao);
      else if(a.temPos && !b.temPos)
        return -1;
      else if(!a.temPos && b.temPos)
        return 1;
      else
        return 0;
    });
    return List.generate(participantes.length + 1, (index){
    if(index == 0)
    return TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0, left: 8),
                    child: Text(
                      'Pos',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0, left: 8),
                    child: Text(
                      'Competidor',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0, left: 8),
                    child: Text(
                      'Tempo',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ]);
      else{
        bool temPos = participantes[index - 1].temPos;
        String indexStr = temPos ? index.toString() : '';
        String nome = participantes[index - 1].nome;
        String unidade = participantes[index - 1].unidade;
        String tempo = temPos && participantes[index - 1].posicao <= 5? participantes[index - 1].tempoString : '';

        return competitorRow(indexStr, nome, unidade, tempo);
      }
  });
  }


  TableRow competitorRow(
      String pos, String nome, String unidade, String tempo) {
    return TableRow(
      children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          pos,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              nome,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis,
            ),
            Text(unidade, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          tempo,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados Rústica'),
      ),
      // TODO:: Usar Dados reais
      body: FutureBuilder(
        future: HandleData().getParticipantesRustica(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(),);
          else{
            if(!snapshot.hasData){
              return Center(child: Text('Nenhum resultado para mostrar'),);
            }else{
              return ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 16),
                child: Table(
                  columnWidths: <int, TableColumnWidth>{
                    0: FixedColumnWidth(10),
                    1: FixedColumnWidth(200),
                    2: FixedColumnWidth(80),
                    3: FixedColumnWidth(0),
                  },
                  children: tableRows(snapshot.data),
                ),
              )
            ],
          );
            }
          }
            
        }
      ),
    );
  }
}
