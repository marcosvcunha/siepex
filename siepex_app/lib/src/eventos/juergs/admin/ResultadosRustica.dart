import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:siepex/src/eventos/juergs/Widgets/confirmDialog.dart';
import 'package:siepex/src/eventos/juergs/Widgets/squarishButton.dart';
import 'package:siepex/src/eventos/juergs/admin/SelececionarParticipanteRustica.dart';
import 'package:siepex/src/eventos/juergs/models/ParticipanteRustica.dart';
import 'package:siepex/src/eventos/juergs/models/equipe.dart';
import 'package:siepex/src/eventos/juergs/models/handledata.dart';

class ResultadosRustica extends StatefulWidget {
  @override
  _ResultadosRusticaState createState() => _ResultadosRusticaState();
}

class _ResultadosRusticaState extends State<ResultadosRustica> {
  List<ParticipanteRustica> participantes;
  // Lista que armazena o ID do participante e tempo que o ADM entrou para cada posição.
  // É iniciada em loadData, após ter sido carregado todos os participantes.

  bool _loading = false;
  List<Widget> tableRows(
      int listSize, List<ParticipanteRustica> participantes) {
    return List.generate(listSize + 1, (index) {
      if (index == 0)
        return FlatButton(
          onPressed: () {},
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Row(children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12.0, left: 8),
                child: Text(
                  'Pos',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12.0, left: 8),
                child: Text(
                  'Competidor',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12.0, left: 8),
                child: Text(
                  'Tempo',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ]),
        );
      else {
        // participantes.sort((a, b){
        //   if(a.temPos && b.temPos)
        //     return a.posicao.compareTo(b.posicao);
        //   else if(a.temPos && !b.temPos)
        //     return -1;
        //   else if(!a.temPos && b.temPos)
        //     return 1;
        //   else
        //     return 0;
        // });
        int idxPart = participantes.indexWhere((item) => item.posicao == index);
        // print('Index do participante: ' + idxPart.toString());
        String nome = 'Selecionar';
        String unidade = 'Local';
        String tempo = '';
        if (idxPart >= 0) {
          nome = participantes[idxPart].nome;
          unidade = participantes[idxPart].unidade;
          tempo = participantes[idxPart].posicao <= 5 ? participantes[idxPart].tempoString : '';
        }
        return competitorRow(index, nome, unidade, tempo);
      }
    });
  }

  Widget competitorRow(int pos, String nome, String unidade, String tempo) {
    List<ParticipanteRustica> parts = List.from(participantes);
    parts.removeWhere((item) => item
        .temPos); // Retira da lista de selecionaveis os que já foram selecionados.

    return FlatButton(
      onPressed: () async {
        // A pagina SelecionarParticipanteRustica retornará o cpf do participante selecionado (ou null se não selecionar ninguem)
        String result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SelececionarPartRustica(
                      participantes: parts,
                      position: pos,
                    )));
        if (result != null) {
          int oldIdx = participantes.indexWhere(
              (item) => item.posicao == pos); // Index do participante que
          // estava nesta posição anteriormente
          print('Posição selecionada: ' + pos.toString());
          if (oldIdx != -1) {
            participantes[oldIdx].posicao = 0;
            participantes[oldIdx].temPos = false;
          }
          int newIdx = participantes.indexWhere((item) => item.cpf == result);
          print('Nome do participante selecionado: ' +
              participantes[newIdx].nome);
          if(pos <= 5){
            int tempo = await timeInputDialog(context);
            participantes[newIdx].tempo = tempo;
          }
          participantes[newIdx].temPos = true;
          participantes[newIdx].posicao = pos;
          setState(() {
            
          });
        }
      },
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              pos.toString(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  nome,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  unidade,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              tempo,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ]),
    );
  }

  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    _loading = true;
    setState(() {});
    print('Carregando');
    participantes = await HandleData().getParticipantesRustica();
    _loading = false;
    setState(() {});
  }

  Future<int> timeInputDialog(
      BuildContext context) async {
    TextEditingController _controllerSeg = TextEditingController();
    TextEditingController _controllerMili = TextEditingController();
    int returlVal = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Digite o tempo do competidor:',
              style: TextStyle(color: Colors.black),
            ),
            content: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
              decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(4),
                    labelText: 'Segundos',
                    border: OutlineInputBorder()),
              style: TextStyle(color: Colors.black),
              controller: _controllerSeg,
            ),
                ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(4),
                    labelText: 'Milésimos',
                    border: OutlineInputBorder()),
                style: TextStyle(color: Colors.black),
                controller: _controllerMili,
              ),
            ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    int seg = 0;
                    int mili = 0;
                    if(_controllerSeg.text.isNotEmpty)
                      seg = double.parse(_controllerSeg.text.replaceAll(',', '.')).floor()*1000;
                    if(_controllerMili.text.isNotEmpty)
                      mili = double.parse(_controllerMili.text.replaceAll(',', '.')).floor();
                    int time = seg + mili;
                    Navigator.pop(context, time);
                  },
                  child: Text('Confimar')),
            ],
          );
        });
    return returlVal;
  }

  Widget botaoLimpar() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: FlatButton(
          onPressed: () async {
            bool confirm = await confirmDialogWithReturn(context, 'Aviso',
                'Tem certeza que deseja limpar todas alterações?');
            if (confirm) {
              for (ParticipanteRustica part in participantes) {
                part.temPos = false;
                part.posicao = 0;
                part.tempo = 0;
              }
              setState(() {});
            }
          },
          child: Text(
            'Limpar Tudo',
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => confirmDialogWithReturn(context, 'Aviso',
          'Tem certeza que deseja retornar? As alterações serão perdidas.'),
      child: Scaffold(
        appBar: AppBar(title: Text('Lançar Resultados Rústica')),
        body: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 12.0, left: 12, right: 12),
                    child: Text(
                      'Selecione uma posição para preencher:',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                  ),
                  botaoLimpar(),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 0),
                    child: Column(
                      children: tableRows(participantes.length, participantes),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: squarishButton('Confirmar', () async {
                      bool confirm = await confirmDialogWithReturn(context, 'Atenção', 'Tem certeza que deseja confimar as alterações?');
                      if(confirm){
                        HandleData().updateRustica(context, participantes);
                        Navigator.pop(context);
                      }
                    }),
                  ),
                ],
              ),
      ),
    );
  }
}
