import 'dart:convert';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:siepex/models/modalidade.dart';
import 'package:siepex/src/config.dart';
import 'package:siepex/src/eventos/juergs/models/handledata.dart';
import 'package:siepex/src/eventos/juergs/models/jogo.dart';

class TabelaGrupos extends StatefulWidget {
  TabelaGrupos(Modalidade modalidade) {
    globalModalidade = modalidade;
  }

  @override
  _TabelaGruposState createState() => _TabelaGruposState();
}


/// Esta classe foi unificada com a classe Jogo, no diretorio models.
// class JogosJuers {
//   String timeA;
//   String timeB;
//   int idTimeA;
//   int idTimeB;
//   int resultadoA;
//   int resultadoB;
//   bool encerrado;
//   int classModalidade;
//   String etapaJogo;

//   JogosJuers.retornaLinhaJuergs(Map<String, dynamic> json) {
//     this.timeA = json['time_a'];
//     this.timeB = json['time_b'];
//     this.idTimeA = json['id_time_a'];
//     this.idTimeB = json['id_time_b'];
//     this.resultadoA = json['resultado_a'];
//     this.resultadoB = json['resultado_b'];
//     this.encerrado = json['encerrado'];
//     this.classModalidade = json['modalidade'];
//     this.etapaJogo = json['etapa_jogo'];
//   }


// }

class TimeFaseGrupo{
  String nome;
  int id;
  int vitorias;
  int derrotas;
  int empates;

  get pontos{
    return vitorias * 3 + empates;
  }

  get partidas{
    return vitorias + empates + derrotas;
  }

  TimeFaseGrupo(String nome_equipe, int id_equipe){
    nome = nome_equipe;
    id = id_equipe;
    vitorias = 0;
    derrotas = 0;
    empates = 0;
  }
}

Modalidade globalModalidade;

class _TabelaGruposState extends State<TabelaGrupos> {
  List<bool> showTable = List.generate(8, (index) {
    return true;
  });
  // Apenas para demonstração
  List<String> _groupsFutsal = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];

  TableRow tableRow(String time, int partidas, int vitorias, int derrotas,
      int empates, int pontos) {
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

  Widget tabela(int index, List<Jogo> retJogos) {
    List<TimeFaseGrupo> times = [
      TimeFaseGrupo(retJogos[0].timeA, retJogos[0].idTimeA),
      TimeFaseGrupo(retJogos[0].timeB, retJogos[0].idTimeB),
      TimeFaseGrupo(retJogos[1].timeB, retJogos[1].idTimeB),
    ];
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

    if (retJogos[0].resultA > retJogos[0].resultB) {
      times[0].vitorias ++;
      times[1].derrotas ++;
    } else if (retJogos[0].resultA < retJogos[0].resultB) {
      times[1].vitorias ++;
      times[0].derrotas ++;
    } else {
      times[0].empates ++;
      times[1].empates ++;
    }
    if (retJogos[1].resultA > retJogos[1].resultB) {
      times[0].vitorias ++;
      times[2].derrotas ++;
    } else if (retJogos[1].resultA < retJogos[1].resultB) {
      times[2].vitorias ++;
      times[0].derrotas ++;
    } else {
      times[0].empates ++;
      times[2].empates ++;
    }
    if (retJogos[2].resultA > retJogos[2].resultB) {
      times[1].vitorias ++;
      times[2].derrotas ++;
    } else if (retJogos[2].resultA < retJogos[2].resultB) {
      times[1].derrotas ++;
      times[2].vitorias ++;
    } else {
      times[1].empates ++;
      times[2].empates ++;
    }
    times.sort((a, b) => b.pontos.compareTo(a.pontos));

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
              child: Text('Grupo ' + _groupsFutsal[index].toString(),
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
                tableRow(times[0].nome, times[0].partidas, times[0].vitorias,
                    times[0].derrotas, times[0].empates, times[0].pontos),
                tableRow(times[1].nome, times[1].partidas, times[1].vitorias,
                    times[1].derrotas, times[1].empates, times[1].pontos),
                tableRow(times[2].nome, times[2].partidas, times[2].vitorias,
                    times[2].derrotas, times[2].empates, times[2].pontos),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 7.0, right: 8),
                child: Container(
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

  Widget _jogoTile(String timeA, int resultadoA, String timeB, int resultadoB) {
    return Container(
      decoration: BoxDecoration(
        border: Border(),
      ),
      height: 60,
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
                    child: Center(
                        child: Text(
                      resultadoA.toString(),
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    )),
                  ),
                ),
              ),
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

  Widget jogosCard(int index, List<Jogo> jogosJuers) {
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
              child: Text('Grupo ' + _groupsFutsal[index].toString(),
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 22,
                      fontWeight: FontWeight.w500)),
            ),
            _jogoTile(jogosJuers[0].timeA, jogosJuers[0].resultA,
                jogosJuers[0].timeB, jogosJuers[0].resultB),
            _jogoTile(jogosJuers[1].timeA, jogosJuers[1].resultA,
                jogosJuers[1].timeB, jogosJuers[1].resultB),
            _jogoTile(jogosJuers[2].timeA, jogosJuers[2].resultA,
                jogosJuers[2].timeB, jogosJuers[2].resultB),
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

  // Future<List<JogosJuers>> listarJogos(ehUsuario) async {
  //   var resposta =
  //       jsonDecode((await http.put(baseUrl + 'modalidades/listaTabela', body: {
  //     'idModalidade': globalModalidade.id.toString(),
  //     (!ehUsuario) ? 'etapa': globalModalidade.fase.toString() : ''
  //   }))
  //           .body);
  //   List<JogosJuers> listaJogos = new List<JogosJuers>();

  //   if (resposta['status'] != null) {
  //     if (resposta['status'] == 'ok') {
  //       for (int i = 0; i != resposta['count']; i++) {
  //         JogosJuers jogosJuergs =
  //             new JogosJuers.retornaLinhaJuergs(resposta['data'][i]);
  //         listaJogos.add(jogosJuergs);
  //       }
  //       return listaJogos;
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Modalidade modalidade = Provider.of<Modalidade>(context);
    HandleData _handleData = HandleData();
    return FutureBuilder(
        future: _handleData.listarJogos(modalidade, 1),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<Jogo> retJogos = snapshot.data;
            if (retJogos.length == 0) {
              return MaterialApp(
                home: Scaffold(
                  appBar: AppBar(
                    title: Text("Nada para mostrar"),
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: _groupsFutsal.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return SizedBox(height: 70);
                }
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  child: showTable[index - 1]
                      ? tabela(
                          index - 1,
                          retJogos.sublist(
                              (index - 1) * 3, ((index - 1) * 3) + 3))
                      : jogosCard(
                          index - 1,
                          retJogos.sublist(
                              (index - 1) * 3, ((index - 1) * 3) + 3)),
                );
              },
            );
          }
        });
  }
}
