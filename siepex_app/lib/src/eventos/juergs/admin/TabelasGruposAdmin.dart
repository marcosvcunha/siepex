import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:siepex/src/config.dart';
import 'package:siepex/src/eventos/juergs/models/handledata.dart';
import 'package:siepex/src/eventos/juergs/tabelas/PaginaTabela.dart';

class TabelaGruposAdmin extends StatefulWidget {
  TabelaGruposAdmin(int modalidade) {
    globalModalidade = modalidade;
  }

  @override
  _TabelaGruposAdminState createState() => _TabelaGruposAdminState();
}

class JogosJuers {
  String timeA;
  String timeB;
  int idTimeA;
  int idTimeB;
  int resultadoA;
  int resultadoB;
  bool encerrado;
  int classModalidade;
  String etapaJogo;

  // cricao de variaveis q ira salvar na base

  // fim da criacao de variaveis
  JogosJuers.retornaLinhaJuergs(Map<String, dynamic> json) {
    this.timeA = json['time_a'];
    this.timeB = json['time_b'];
    this.idTimeA = json['id_time_a'];
    this.idTimeB = json['id_time_b'];
    this.resultadoA = json['resultado_a'];
    this.resultadoB = json['resultado_b'];
    this.encerrado = json['encerrado'];
    this.classModalidade = json['modalidade'];
    this.etapaJogo = json['etapa_jogo'];
  }
}

int globalModalidade;

class _TabelaGruposAdminState extends State<TabelaGruposAdmin> {
  List<bool> showTable = List.generate(8, (index) {
    return true;
  });

  bool _isEditingText = false;
  List<TextEditingController> controllers;
  String initialText = "1";
  int crtlIndex = 0;
  int globalIndex = 0;
  int tapIndex = 0;
  @override
  void initState() {
    super.initState();
    controllers = List.generate(42, (i) => TextEditingController());
  }

  @override
  void dispose() {
    controllers.forEach((c) => c.dispose());
    super.dispose();
  }

  // Apenas para demonstração
  List<String> _groups = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];

  TableRow tableRow(
      String time, int partidas, int vitorias, int derrotas, int pontos) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.only(top: 4.0, bottom: 4, left: 6),
        child: Text(
          time,
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
          top: 4.0,
          bottom: 4,
        ),
        child: Text(
          partidas.toString(),
          style: TextStyle(color: Colors.black, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
          top: 4.0,
          bottom: 4,
        ),
        child: Text(
          vitorias.toString(),
          style: TextStyle(color: Colors.black, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
          top: 4.0,
          bottom: 4,
        ),
        child: Text(
          derrotas.toString(),
          style: TextStyle(color: Colors.black, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
          top: 4.0,
          bottom: 4,
        ),
        child: Text(
          pontos.toString(),
          style: TextStyle(color: Colors.black, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    ]);
  }

  Widget _jogoTile(String timeA, int resultadoA, String timeB, int resultadoB,
      List<JogosJuers> jogosJuergs) {
    return Container(
      decoration: BoxDecoration(
        //color: Colors.blue,
        border: Border(
            //bottom: BorderSide(color: Colors.deepPurple, width: 2)
            ),
      ),
      height: 60,
      //width: 240,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      timeA,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )),
              Expanded(
                flex: 1,
                child: Center(
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color.fromRGBO(0x67, 0x44, 0xc7, 0.70)),
                      height: 35,
                      width: 35,
                      child: _editTitleTextField(jogosJuergs)),
                ),
              ),
              // SizedBox(width: 30),
              Expanded(
                flex: 1,
                child: Center(
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color.fromRGBO(0x67, 0x44, 0xc7, 0.70)),
                      height: 35,
                      width: 35,
                      child: _editTitleTextField(jogosJuergs)),
                ),
              ),
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(
                      timeB,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )),
            ],
          ),
          Text(
            'Ginasio Local, 23/09 17:30',
            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }

  Widget jogosCard(int index, List<JogosJuers> jogosJuers) {
    return Padding(
      key: ValueKey(2),
      padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Container(
        height: 290,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                blurRadius: 3,
                spreadRadius: 1,
                color: Colors.grey[500],
                offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 14.0, bottom: 12),
              child: Text('Grupo ' + _groups[index].toString(),
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 22,
                      fontWeight: FontWeight.w500)),
            ),
            _jogoTile(jogosJuers[0].timeA, jogosJuers[0].resultadoA,
                jogosJuers[0].timeB, jogosJuers[0].resultadoB, jogosJuers),
            _jogoTile(jogosJuers[1].timeA, jogosJuers[1].resultadoA,
                jogosJuers[1].timeB, jogosJuers[1].resultadoB, jogosJuers),
            _jogoTile(jogosJuers[2].timeA, jogosJuers[2].resultadoA,
                jogosJuers[2].timeB, jogosJuers[2].resultadoB, jogosJuers),
          ],
        ),
      ),
    );
  }

  Future<List<JogosJuers>> listarJogos() async {
    var resposta = jsonDecode((await http.put(
            baseUrl + 'modalidades/listaTabela',
            body: {'idModalidade': globalModalidade.toString()}))
        .body);
    List<JogosJuers> listaJogos = new List<JogosJuers>();

    if (resposta['status'] != null) {
      if (resposta['status'] == 'ok') {
        for (int i = 0; i != resposta['count']; i++) {
          JogosJuers jogosJuergs =
              new JogosJuers.retornaLinhaJuergs(resposta['data'][i]);
          listaJogos.add(jogosJuergs);
        }
        return listaJogos;
      }
    }
  }

  Widget _editTitleTextField(List<JogosJuers> jogosJuergs) {
    if (globalIndex % 2 != 0) {
      initialText = jogosJuergs[crtlIndex].resultadoB.toString();
      crtlIndex++;
    } else {
      initialText = jogosJuergs[crtlIndex].resultadoA.toString();
    }
    if (crtlIndex == 3) {
      crtlIndex = 0;
    }

    if (_isEditingText)
      return Center(
        child: TextField(
          controller: controllers[globalIndex],
          onChanged: (value) {
            final controller = controllers[globalIndex];
          },
        ),
      );
    globalIndex++;
    return InkWell(
      onTap: () {
        setState(() {
          _isEditingText = true;
        });
      },
      child: Text(
        initialText,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: listarJogos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<JogosJuers> retJogos = snapshot.data;
            return ListView.builder(
              itemCount: 8,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return SizedBox(height: 70);
                }
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  child: jogosCard(index - 1,
                      retJogos.sublist((index - 1) * 3, ((index - 1) * 3) + 3)),
                );
              },
            );
          }
        });
  }
}
