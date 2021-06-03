import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:siepex/src/eventos/juergs/models/modalidade.dart';
import 'package:siepex/src/eventos/juergs/models/handledata.dart';
import 'package:siepex/src/eventos/juergs/models/jogo.dart';


class TimeFaseGrupo {
  String nome;
  int id;
  int vitorias;
  int derrotas;
  int empates;

  get pontos {
    return vitorias * 3 + empates;
  }

  get partidas {
    return vitorias + empates + derrotas;
  }

  TimeFaseGrupo(String nome_equipe, int id_equipe) {
    nome = nome_equipe;
    id = id_equipe;
    vitorias = 0;
    derrotas = 0;
    empates = 0;
  }
}

class TabelaGrupos extends StatefulWidget {

  @override
  _TabelaGruposState createState() => _TabelaGruposState();
}

class _TabelaGruposState extends State<TabelaGrupos> {
  List<bool> showTable = List.generate(8, (index) {
    return true;
  });
  // Apenas para demonstração
  // List<String> _groupsFutsal = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];

  @override
  Widget build(BuildContext context) {
    Modalidade modalidade = Provider.of<Modalidade>(context);
    List<String> _groupsFutsal;
    int numJogos;

    if(modalidade.formatoCompeticao == 32){
      _groupsFutsal = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
      numJogos = 6;
    }else if(modalidade.formatoCompeticao == 24){
      _groupsFutsal = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
      numJogos = 3;      
    }else if(modalidade.formatoCompeticao == 16){
      _groupsFutsal = ['A', 'B', 'C', 'D'];
      numJogos = 6;
    }else if(modalidade.formatoCompeticao == 12){
      _groupsFutsal = ['A', 'B', 'C', 'D'];
      numJogos = 3;
    }

    return FutureBuilder(
        future: Jogo.pegaJogoPorFase(context, modalidade, Modalidade.fasesMap['Fase de Grupos']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<Jogo> retJogos = snapshot.data;
            if (retJogos.length == 0) {
              return Center(child: Text('Nada para mostrar'));
            }
            return ListView.builder(
              itemCount: _groupsFutsal.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return SizedBox(height: 70);
                }
                return GrupoCard(
                    jogos: retJogos.sublist((index - 1) * numJogos, ((index - 1) * numJogos) + numJogos),
                    nomeGrupo: 'Grupo ' + _groupsFutsal[index - 1], modalidade: modalidade,);
              },
            );
          }
        });
  }
}

class GrupoCard extends StatefulWidget {
  final List<Jogo> jogos;
  final String nomeGrupo;
  final Modalidade modalidade;
  GrupoCard({this.jogos, this.nomeGrupo, this.modalidade});
  @override
  _GrupoCardState createState() => _GrupoCardState();
}

class _GrupoCardState extends State<GrupoCard> {
  List<String> _groupsFutsal = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
  bool showTable;
  List<Jogo> retJogos;
  List<TimeFaseGrupo> times;
  Modalidade modalidade;
  List<TableRow> linhasTimes;
  List<Widget> linhaJogos;

  // [
  //     TimeFaseGrupo(retJogos[0].timeA, retJogos[0].idTimeA),
  //     TimeFaseGrupo(retJogos[0].timeB, retJogos[0].idTimeB),
  //     TimeFaseGrupo(retJogos[1].timeB, retJogos[1].idTimeB),
  //   ];

  void initState() {
    super.initState();
    showTable = true;
    retJogos = widget.jogos;
    modalidade = widget.modalidade;
    
    print(modalidade.formatoCompeticao);
    if(modalidade.formatoCompeticao == 32){
      times = [
      TimeFaseGrupo(retJogos[0].timeA, retJogos[0].idTimeA),
      TimeFaseGrupo(retJogos[0].timeB, retJogos[0].idTimeB),
      TimeFaseGrupo(retJogos[1].timeB, retJogos[1].idTimeB),
      TimeFaseGrupo(retJogos[2].timeB, retJogos[2].idTimeB),
      ];
    }else if(modalidade.formatoCompeticao == 24){
      times = [
        TimeFaseGrupo(retJogos[0].timeA, retJogos[0].idTimeA),
        TimeFaseGrupo(retJogos[0].timeB, retJogos[0].idTimeB),
        TimeFaseGrupo(retJogos[1].timeA, retJogos[1].idTimeA),
      ];
    }else if(modalidade.formatoCompeticao == 16){
      times = [
        TimeFaseGrupo(retJogos[0].timeA, retJogos[0].idTimeA),
        TimeFaseGrupo(retJogos[0].timeB, retJogos[0].idTimeB),
        TimeFaseGrupo(retJogos[1].timeB, retJogos[1].idTimeB),
        TimeFaseGrupo(retJogos[2].timeB, retJogos[2].idTimeB),
      ];
    }else if(modalidade.formatoCompeticao == 12){
      times = [
        TimeFaseGrupo(retJogos[0].timeA, retJogos[0].idTimeA),
        TimeFaseGrupo(retJogos[0].timeB, retJogos[0].idTimeB),
        TimeFaseGrupo(retJogos[1].timeA, retJogos[1].idTimeA),
      ];
    }

    // Calcula pontos
    for(Jogo jogo in retJogos){
      if(jogo.encerrado){
      if(jogo.resultA > jogo.resultB){
        int idVencedor = times.indexWhere((element){return element.nome == jogo.timeA;});
        int idPerdedor = times.indexWhere((element){return element.nome == jogo.timeB;});
        times[idVencedor].vitorias++;
        times[idPerdedor].derrotas++;
      }else if(jogo.resultA < jogo.resultB){
        int idVencedor = times.indexWhere((element){return element.nome == jogo.timeB;});
        int idPerdedor = times.indexWhere((element){return element.nome == jogo.timeA;});
        times[idVencedor].vitorias++;
        times[idPerdedor].derrotas++;
      }else{
        int idTimeA = times.indexWhere((element){return element.nome == jogo.timeA;});
        int idTimeB = times.indexWhere((element){return element.nome == jogo.timeB;});
        times[idTimeA].empates++;
        times[idTimeB].empates++;
      }
      }
    }
    times.sort((a, b) => b.pontos.compareTo(a.pontos));
  }

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

  Widget _jogoTile(Jogo jogo) {
    String timeA = jogo.timeA;
    String resultadoA = jogo.encerrado ? jogo.resultA.toString() : '-';
    String timeB = jogo.timeB;
    String resultadoB = jogo.encerrado ? jogo.resultB.toString() : '-';
    return Container(
      decoration: BoxDecoration(
        border: Border(),
      ),
      // height: 60,
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
                        color: Color.fromRGBO(0x67, 0x44, 0xc7, 0.2)),
                    height: 35,
                    width: 35,
                    child: Center(
                        child: Text(
                      resultadoA,
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
                        color: Color.fromRGBO(0x67, 0x44, 0xc7, 0.2)),
                    height: 35,
                    width: 35,
                    child: Center(
                        child: Text(
                      resultadoB,
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
          // SizedBox(height: 8,),
          Text(jogo.local, style: TextStyle(color: Colors.grey[800])),
          // Text(
          //   jogo.encerrado ? 'Encerrado' : 'Não Iniciou',
          //   style: TextStyle(fontSize: 14, color: Colors.grey[800]),
          // ),
          SizedBox(height: 16,),
        ],
      ),
    );
  }

  Widget tabela() {
    return Padding(
      key: ValueKey(1),
      padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Container(
        // height: 230,
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
              child: Text(widget.nomeGrupo,
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
                    BorderSide(color: Colors.deepPurple.withOpacity(0.5), width: 2),
                verticalInside: BorderSide(color: Colors.deepPurple.withOpacity(0.5), width: 2),
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
              ] + linhasTimes,
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
                          showTable = false;
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

  Widget jogosCard(List<Jogo> jogosJuers) {
    return Padding(
      key: ValueKey(2),
      padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Container(
        // height: 290,
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
              child: Text(widget.nomeGrupo,
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 22,
                      fontWeight: FontWeight.w500)),
            ),]
              +
              linhaJogos
              +
            [
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
                          showTable = true;
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

  @override
  Widget build(BuildContext context) {
    linhasTimes = List.generate(times.length, 
    (index){
      return tableRow(times[index].nome, times[index].partidas, times[index].vitorias,
        times[index].derrotas, times[index].empates, times[index].pontos);
    });
    
    linhaJogos = List.generate(retJogos.length, (index){
      return _jogoTile(retJogos[index]);
    });

    return AnimatedSwitcher(
      transitionBuilder: (child, animation) => SizeTransition(
        child: child,
        sizeFactor: animation,
      ),
      duration: Duration(milliseconds: 200),
      child: showTable
          ? tabela()
          : jogosCard(widget.jogos),
    );
  }
}
