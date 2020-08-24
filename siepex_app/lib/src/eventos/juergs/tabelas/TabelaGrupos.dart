import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:siepex/models/modalidade.dart';
import 'package:siepex/src/config.dart';
import 'package:siepex/src/eventos/juergs/models/handledata.dart';
import 'package:siepex/src/eventos/juergs/tabelas/PaginaTabela.dart';

class TabelaGrupos extends StatefulWidget {
  TabelaGrupos(Modalidade modalidade) {
    globalModalidade = modalidade;
  }

  @override
  _TabelaGruposState createState() => _TabelaGruposState();
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

Modalidade globalModalidade;

class _TabelaGruposState extends State<TabelaGrupos> {
  List<bool> showTable = List.generate(8, (index) {
    return true;
  });
  // Apenas para demonstração
  List<String> _groups = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];

  TableRow tableRow(String time, int partidas, int vitorias, int derrotas, int empates, int pontos) {
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
          empates.toString(),
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

  Widget tabela(int index, List<JogosJuers> retJogos) {
    int partidasTime1 = 0;
    int ptsTime1 = 0;
    int vitoriasTime1 = 0;
    int derrotasTime1 = 0;
    int empatesTime1 = 0;
    int partidasTime2 = 0;
    int ptsTime2 = 0;
    int vitoriasTime2 = 0;
    int derrotasTime2 = 0;
    int empatesTime2 = 0;
    int partidasTime3 = 0;
    int ptsTime3 = 0;
    int vitoriasTime3 = 0;
    int derrotasTime3 = 0;
    int empatesTime3 = 0;
    if(retJogos[0].encerrado){
      partidasTime1++;
      partidasTime2++;
    }
    if(retJogos[1].encerrado){
      partidasTime1++;
      partidasTime3++;
    }
    if(retJogos[2].encerrado){
      partidasTime2++;
      partidasTime3++;
    }
    if(retJogos[0].resultadoA > retJogos[0].resultadoB){
      ptsTime1 += 3;
      vitoriasTime1++;
      derrotasTime2++;
    }
    else if(retJogos[0].resultadoA < retJogos[0].resultadoB){
      ptsTime2 += 3;
      vitoriasTime2++;
      derrotasTime1++;
    }
    else{
      empatesTime1++;
      empatesTime2++;
      ptsTime1++;
      ptsTime2++;
    }
    if(retJogos[1].resultadoA > retJogos[1].resultadoB){
      ptsTime1 += 3;
      vitoriasTime1++;
      derrotasTime3++;
    }
    else if(retJogos[1].resultadoA < retJogos[1].resultadoB){
      ptsTime3 += 3;
      vitoriasTime3++;
      derrotasTime1++;
    }
    else{
      empatesTime1++;
      empatesTime3++;
      ptsTime1++;
      ptsTime3++;
    }
    if(retJogos[2].resultadoA > retJogos[2].resultadoB){
      ptsTime2 += 3;
      vitoriasTime2++;
      derrotasTime3++;
    }
    else if(retJogos[2].resultadoA < retJogos[2].resultadoB){
      ptsTime3 += 3;
      vitoriasTime3++;
      derrotasTime2++;
    }
    else{
      empatesTime2++;
      empatesTime3++;
      ptsTime2++;
      ptsTime3++;
    }
    return Padding(
      key: ValueKey(1),
      padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Container(
        height: 230,
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
            Table(
              columnWidths: {
                0: FixedColumnWidth(150),
                1: FixedColumnWidth(40),
                2: FixedColumnWidth(40),
                3: FixedColumnWidth(40),
                4: FixedColumnWidth(40)
              },
              border: TableBorder(
                //bottom: BorderSide(color: Colors.deepPurple, width: 2),
                //left:  BorderSide(color: Colors.deepPurple, width: 2),
                //right:  BorderSide(color: Colors.deepPurple, width: 2),
                //top:  BorderSide(color: Colors.deepPurple, width: 2),
                horizontalInside:
                    BorderSide(color: Colors.deepPurple, width: 2),
                verticalInside: BorderSide(color: Colors.deepPurple, width: 2),
              ),
              children: [
                TableRow(children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 4.0, bottom: 4, left: 6),
                    child: Text(
                      'Time',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4.0,
                      bottom: 4,
                    ),
                    child: Text(
                      'J',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4.0,
                      bottom: 4,
                    ),
                    child: Text(
                      'V',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4.0,
                      bottom: 4,
                    ),
                    child: Text(
                      'D',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4.0,
                      bottom: 4,
                    ),
                    child: Text(
                      'E',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                                    Padding(
                    padding: const EdgeInsets.only(
                      top: 4.0,
                      bottom: 4,
                    ),
                    child: Text(
                      'P',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),                
                tableRow(retJogos[0].timeA, partidasTime1, vitoriasTime1, derrotasTime1, empatesTime1, ptsTime1),
                tableRow(retJogos[0].timeB, partidasTime2, vitoriasTime2, derrotasTime2, empatesTime2, ptsTime2),
                tableRow(retJogos[1].timeB, partidasTime3, vitoriasTime3, derrotasTime3, empatesTime3, ptsTime3),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 7.0, right: 8),
                child: Container(
                    //color: Colors.green,
                    height: 45,
                    width: 120,
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          showTable[index] = false;
                        });
                      },
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.swap_horiz,
                            size: 32,
                            color: Colors.red,
                          ),
                          Text(
                            'Jogos',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _jogoTile(String timeA, int resultadoA,String timeB, int resultadoB) {
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
                        //color: Colors.grey[400],
                        //6744C7
                        color: Color.fromRGBO(0x67, 0x44, 0xc7, 0.70)),
                    height: 35,
                    width: 35,
                    child: Center(
                        child: Text(
                      resultadoA.toString(),
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    )),
                  ),
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
                    child: Center(
                        child: Text(
                      resultadoB.toString(),
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    )),
                  ),
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
            _jogoTile(jogosJuers[0].timeA, jogosJuers[0].resultadoA, jogosJuers[0].timeB, jogosJuers[0].resultadoB),
            _jogoTile(jogosJuers[1].timeA, jogosJuers[1].resultadoA, jogosJuers[1].timeB, jogosJuers[1].resultadoB),
            _jogoTile(jogosJuers[2].timeA, jogosJuers[2].resultadoA, jogosJuers[2].timeB, jogosJuers[2].resultadoB),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 7.0, right: 8),
                child: Container(
                    //color: Colors.green,
                    height: 45,
                    width: 120,
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          showTable[index] = true;
                        });
                      },
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.swap_horiz,
                            size: 32,
                            color: Colors.red,
                          ),
                          Text(
                            'Tabela',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<JogosJuers>> listarJogos() async {
    var resposta = jsonDecode((await http.put(
            baseUrl + 'modalidades/listaTabela',
            body: {'idModalidade': globalModalidade.id.toString(), 'etapa': globalModalidade.fase.toString()}))
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
                  child: showTable[index - 1]
                      ? tabela(index - 1, retJogos.sublist((index-1)*3, ((index-1)*3)+3))
                      : jogosCard(index - 1, retJogos.sublist((index-1)*3, ((index-1)*3)+3)),
                );
                // return showTable[index - 1] ? tabela(index - 1) : jogosCard(index - 1);
              },
            );
          }
        });
  }
}
