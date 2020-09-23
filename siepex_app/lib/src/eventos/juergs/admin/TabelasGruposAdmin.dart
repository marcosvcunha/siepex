import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:siepex/models/modalidade.dart';
import 'package:siepex/src/config.dart';
import 'package:siepex/src/eventos/juergs/models/handledata.dart';
import 'package:siepex/src/eventos/juergs/tabelas/PaginaTabela.dart';

class TabelaGruposAdmin extends StatefulWidget {
  TabelaGruposAdmin(Modalidade modalidade) {
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

Modalidade globalModalidade;

class _TabelaGruposAdminState extends State<TabelaGruposAdmin> {
  List<bool> showTable = List.generate(8, (index) {
    return true;
  });

  bool jaCarregou = false;
  List<TextEditingController> controllers;
  String initialText = "1";
  int crtlIndex = 0;
  int globalIndex = 0;
  int tapIndex = 0;
  @override
  void initState() {
    super.initState();
    controllers = List.generate(48, (i) => TextEditingController());
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

  Widget _jogoTile(JogosJuers jogo, int index) {
    // _jogoTile(jogosJuers[1].timeA, jogosJuers[1].resultadoA,
    //         jogosJuers[1].timeB, jogosJuers[1].resultadoB, jogosJuers),
    String timeA = jogo.timeA;
    String timeB = jogo.timeB;
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
                      child: Center(
                          child:
                              _editTitleTextField(jogo, 'A', index * 2 + 0))),
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
                          child:
                              _editTitleTextField(jogo, 'B', index * 2 + 1))),
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
            // index = 1; grupo = B;
            _jogoTile(jogosJuers[index * 3 + 0], index * 3 + 0),
            _jogoTile(jogosJuers[index * 3 + 1], index * 3 + 1),
            _jogoTile(jogosJuers[index * 3 + 2], index * 3 + 2),
          ],
        ),
      ),
    );
  }

  Future<List<JogosJuers>> listarJogos() async {
    var resposta =
        jsonDecode((await http.put(baseUrl + 'modalidades/listaTabela', body: {
      'idModalidade': globalModalidade.id.toString(),
      'etapa': globalModalidade.fase.toString()
    }))
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

  Widget _editTitleTextField(
      JogosJuers jogoJuergs, String id, int controllerIndex) {
    return Center(
      child: TextField(
        controller: controllers[controllerIndex],
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ],
        onSubmitted: (value) {
          // if (id == 'A')
          //   controllers[controllerIndex].text =
          //       jogoJuergs.resultadoA.toString();
          // else
          //   controllers[controllerIndex].text =
          //       jogoJuergs.resultadoB.toString();
        },
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
            if (retJogos.length == 0) {
              return MaterialApp(
                home: Scaffold(
                  appBar: AppBar(
                    title: Text("Nada para mostrar"),
                  ),
                ),
              );
            }
            if (!jaCarregou) {
              for (int i = 0; i < retJogos.length; i++) {
                controllers[i * 2 + 0].text = retJogos[i].resultadoA.toString();
                controllers[i * 2 + 1].text = retJogos[i].resultadoB.toString();
              }
              jaCarregou = true;
            }
            return Column(children: [
              Expanded(
                  child: ListView.builder(
                itemCount: 8,
                itemBuilder: (context, index) {
                  return AnimatedSwitcher(
                    duration: Duration(milliseconds: 200),
                    child: jogosCard(index, retJogos),
                  );
                },
              )),
              RaisedButton(
                  child: Text("Salvar"),
                  color: Colors.blue,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  splashColor: Colors.grey,
                  onPressed: () async {
                    var resultados = new StringBuffer();
                    for (TextEditingController textEdit in controllers) {
                      resultados.write(textEdit.text + ',');
                    }
                    var resposta = jsonDecode((await http
                            .put(baseUrl + 'modalidades/lancaResultado', body: {
                      'idModalidade': globalModalidade.id.toString(),
                      'etapa': globalModalidade.fase.toString(),
                      'resultados': resultados.toString(),
                    }))
                        .body);
                  }
                  // fill in required params
                  ),
            ]);
          }
        });
  }
}
