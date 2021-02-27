import 'package:flutter/material.dart';
import 'package:siepex/src/eventos/juergs/models/jogo.dart';
import 'package:provider/provider.dart';

class GameCard extends StatefulWidget {
  final String nomeJogo;
  GameCard({this.nomeJogo});
  @override
  _GameCardState createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  Jogo jogo;
  bool _editable = false;
  int tempResultA;
  int tempResultB;

  Widget result(String time) {
    if (!_editable)
      return Padding(
        padding: const EdgeInsets.only(right: 42.0),
        child: Text(
          time == 'A' ? jogo.resultAStr : jogo.resultBStr,
          style: TextStyle(
            fontSize: 22,
          ),
        ),
      );
    else {
      return Row(
        // mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          InkWell(child: Container(
            child: Icon(Icons.arrow_left, size: 34, color: Colors.red,)),
            onTap: (){
              if(time == 'A')
                tempResultA = tempResultA > 0 ? tempResultA - 1 : 0;
              else
                tempResultB = tempResultB > 0 ? tempResultB - 1 : 0;
              setState(() {
                
              });
            },
            ),
          Text(
            time == 'A' ? tempResultA.toString() : tempResultB.toString(),
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          InkWell(child: Container(child: Icon(Icons.arrow_right, size: 34, color: Colors.green,)),
          onTap: (){
            if(time == 'A')
                tempResultA = tempResultA + 1;
              else
                tempResultB = tempResultB + 1;
              setState(() {
                
              });
          },
          ),
          SizedBox(width: 20),
        ],
      );
    }
  }

  Widget body() {
    // Widget que representa um jogo.
    // Mostra o nome de um time em cima do outro e os gols a direita de cada um.
    // Em cima do card vai o "nome" do jogo: Jogo 1, Jogo 2, ...

    return Padding(
      // alignment: Alignment.center,
      padding: EdgeInsets.only(left: 20, right: 20, top: 14),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                widget.nomeJogo != null ? widget.nomeJogo : jogo.nome,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: 12,
              ),
              IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    if(! _editable){
                      // Vai começar a ser editado.
                      tempResultA = jogo.resultA;
                      tempResultB = jogo.resultB;
                    }else{
                      // Terminou de ser editado
                      if(! jogo.encerrado){
                        // Se o jogo não havia sido encerrado ainda, vai sempre ser editado.
                        jogo.encerrado = true;
                        jogo.edited = true;
                        jogo.resultA = tempResultA;
                        jogo.resultB = tempResultB;
                      }else{
                        // Se o jogo já havia sido dado como encerrado, não há necessidade de fazer alguma atualização
                        // se o resultado não foi alterado.
                        if(jogo.resultA != tempResultA || jogo.resultB != tempResultB){
                          // Pelo menos um dos jogos foi alterados.
                          jogo.resultA = tempResultA;
                          jogo.resultB = tempResultB;
                          jogo.edited = true;
                        }
                      }
                    }
                    _editable = !_editable;
                    jogo.beeingEdited = _editable;
                    setState(() {});
                  },
                  icon: Icon(
                    _editable ? Icons.done : Icons.edit,
                    color: Colors.blue,
                  )),
            ],
          ),
          SizedBox(
            height: 0,
          ),
          Container(
            height: 80,
            width: 600,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  blurRadius: 2,
                  spreadRadius: 2,
                  color: Colors.grey[400],
                  offset: Offset(0, 0),
                ),
              ],
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        jogo.timeA,
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    ),
                    result('A'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        jogo.timeB,
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    ),
                    result('B'),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    jogo = Provider.of<Jogo>(context);
    return body();
  }
}
