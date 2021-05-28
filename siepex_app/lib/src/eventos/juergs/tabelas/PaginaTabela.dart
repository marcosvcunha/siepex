import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siepex/src/eventos/juergs/models/modalidade.dart';
import 'package:siepex/src/eventos/juergs/tabelas/TabelaFinal.dart';
import 'package:siepex/src/eventos/juergs/tabelas/TabelaGrupos.dart';
import 'package:siepex/src/eventos/juergs/tabelas/TabelaQuartas.dart';
import 'package:siepex/src/eventos/juergs/tabelas/TabelaSemi.dart';

class PaginaTabela extends StatefulWidget {
  @override
  _PaginaTabelaState createState() => _PaginaTabelaState();
  
}

class _PaginaTabelaState extends State<PaginaTabela> {
  Modalidade modalidade;

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
                      // Corrigindo o fato da modalidade não ter quartas de final
                      if(modalidade.formatoCompeticao == 12 && _currentFase == 3){
                        _currentFase = 1;
                      }else{
                        _currentFase --;
                      }
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
                      // Corrigindo o fato da modalidade não ter Quartas de Final
                      if(modalidade.formatoCompeticao == 12 && _currentFase == 1){
                        _currentFase = 3;
                      }else{
                        _currentFase ++;
                      }
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
      return TabelaGrupos();
    else if(_currentFase == 2)
      return TabelaQuartas();
    else if(_currentFase == 3)
      return TabelaSemi();
    else
      return TabelaFinal();
  }

  Widget faseDeInscricao(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white
        ),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 100.0, top: 150),
              child: Icon(Icons.error_outline, size: 100, color: Colors.green),
            ),
            Text('A competição ainda não começou', 
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 32
          ),),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Arrumar para não calcular os pontos nem os resultados enquanto a partida não tiver terminado.
    modalidade = Provider.of<Modalidade>(context);
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
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
