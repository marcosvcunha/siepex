import 'package:flutter/material.dart';
import 'package:siepex/models/modalidade.dart';
import 'package:siepex/src/eventos/juergs/tabelas/TabelaFinal.dart';
import 'package:siepex/src/eventos/juergs/tabelas/TabelaGrupos.dart';
import 'package:siepex/src/eventos/juergs/tabelas/TabelaQuartas.dart';
import 'package:siepex/src/eventos/juergs/tabelas/TabelaSemi.dart';

class PaginaTabela extends StatefulWidget {
  @override
  _PaginaTabelaState createState() => _PaginaTabelaState();
  
}

class _PaginaTabelaState extends State<PaginaTabela> {

  int _currentFase = 1;
  List<String> fases = [
  'Inscrição',
  'Fase de Grupos',
  'Quartas de Final',
  'Semi-Final',
  'Final',
  ];
  Widget selectionBar(int modalidadeFase) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  spreadRadius: 2,
                  color: Colors.black54,
                  offset: Offset(0, 2),
                ),
              ]),
          height: 50,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    size: 32,
                    color: _currentFase > 1 ? Colors.green[600] : Colors.grey[500],
                  ),
                  onPressed: _currentFase > 1 ? (){
                    setState(() {
                      _currentFase --;
                    });
                  }:  null,
                ),
              ),
              Text(
                fases[_currentFase],
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: IconButton(
                  icon: Icon(
                    Icons.chevron_right,
                    size: 32,
                    color: _currentFase < modalidadeFase ? Colors.green[600] : Colors.grey[500]
                  ),

                  onPressed: _currentFase < modalidadeFase ? (){
                    setState(() {
                      _currentFase ++;
                    });
                  }:  null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget currentPage(Modalidade modalidade){
    if(_currentFase == 1)
      return TabelaGrupos(modalidade);
    else if(_currentFase == 2)
      return TabelaQuartas();
    else if(_currentFase == 3)
      return TabelaSemi();
    else
      return TabelaFinal();
  }

  Widget faseDeInscricao(){
    return Center(
      child: Text('A competição ainda não começou!', 
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 32
        ),),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Arrumar para não calcular os pontos nem os resultados enquanto a partida não tiver terminado.
    Modalidade modalidade = ModalRoute.of(context).settings.arguments;
    print(modalidade.faseStr);
    return Scaffold(
      backgroundColor: Colors.grey[400],
      // backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Tabela ' + modalidade.nome)),
      body: modalidade.fase == 0 ? faseDeInscricao() : 
        Stack(
        children: <Widget>[
          AnimatedSwitcher(duration: Duration(milliseconds: 200),
          child: currentPage(modalidade),
          ),
          selectionBar(modalidade.fase),
        ],
      ),
      
    );
  }
}
