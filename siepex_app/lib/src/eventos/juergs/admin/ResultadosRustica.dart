import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:siepex/src/eventos/juergs/Widgets/confirmDialog.dart';
import 'package:siepex/src/eventos/juergs/admin/SelececionarParticipanteRustica.dart';
import 'package:siepex/src/eventos/juergs/models/equipe.dart';
import 'package:siepex/src/eventos/juergs/models/handledata.dart';

class ResultadosRustica extends StatefulWidget {
  @override
  _ResultadosRusticaState createState() => _ResultadosRusticaState();
}

class _ResultadosRusticaState extends State<ResultadosRustica> {
  List<Equipe> participantes;
  List<Map> resultados;
  // Lista que armazena o ID do participante e tempo que o ADM entrou para cada posição.
  // É iniciada em loadData, após ter sido carregado todos os participantes.

  bool _loading = false;
  List<Widget> tableRows(
      int listSize, List<Equipe> participantes, List resultados) {
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
        int partIdx = resultados[index - 1]['participante_num'];

        return competitorRow(
            index,
            partIdx >= 0 ? participantes[partIdx].nome : 'Selecione',
            partIdx >= 0 ? 'Guaiba' : 'Local',
            resultados[index - 1]['tempo']);
      }
    });
  }

  Widget competitorRow(int pos, String nome, String unidade, String tempo) {
    return FlatButton(
      onPressed: () async {
        int result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SelececionarPartRustica(
                      participantes: participantes,
                      position: pos,
                    )));
        resultados[pos - 1]['participante_num'] = result - 1; 
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
    participantes = await HandleData().getEquipes(6);
    resultados = List.generate(participantes.length, (index) {
      return {
        'participante_num': -1,
        'tempo': '00:00:000',
      };
    });
    _loading = false;
    setState(() {});
  }

  Future<bool> _confirmReturn() async {
    return await showDialog(
      barrierDismissible: false,

      context: context, 
    child: AlertDialog(
      title: Text('Aviso'),
      content: Text('Tem certeza que deseja retornar? As alterações serão perdidas.'),
      actions: <Widget>[
        FlatButton(onPressed: (){
          Navigator.pop(context, true);
        }, child: Text('Sim')),
        FlatButton(onPressed: (){
          Navigator.pop(context, false);
        }, child: Text('Não')),
      ],
    ),
    
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _confirmReturn,
          child: Scaffold(
        appBar: AppBar(title: Text('Lançar Resultados Rústica')),
        body: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Selecione uma posição para preencher:',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 16),
                    child: Column(
                      children: tableRows(
                          participantes.length, participantes, resultados),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
