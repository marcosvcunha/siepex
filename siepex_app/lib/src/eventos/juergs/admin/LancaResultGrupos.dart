import 'package:flutter/material.dart';
import 'package:siepex/models/modalidade.dart';
import 'package:provider/provider.dart';
import 'package:siepex/src/eventos/juergs/admin/TabelasGruposAdmin.dart';

/*
Seleciona o resultado das partidas para alterar
*/

class LancaResultadosGruposPage extends StatefulWidget {
  @override
  _LancaResultadosGruposPageState createState() => _LancaResultadosGruposPageState();
}

class _LancaResultadosGruposPageState extends State<LancaResultadosGruposPage> {
  bool _isLoading = false;

  Modalidade modalidade;

  int _currentFase = 0;
  List<String> fases = ['1ª Fase', 'Quartas de Final', 'Semi-final', 'Final'];
  Widget selectionBar() {
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
                    color:
                        _currentFase > 0 ? Colors.green[600] : Colors.grey[500],
                  ),
                  onPressed: _currentFase > 0
                      ? () {
                          setState(() {
                            _currentFase--;
                          });
                        }
                      : null,
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
                  icon: Icon(Icons.chevron_right,
                      size: 32,
                      color: _currentFase < 3
                          ? Colors.green[600]
                          : Colors.grey[500]),
                  onPressed: _currentFase < 3
                      ? () {
                          setState(() {
                            _currentFase++;
                          });
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    modalidade = Provider.of<Modalidade>(context);
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(title: Text(modalidade.nome)),
      body: Stack(
        children: <Widget>[
          AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child: TabelaGruposAdmin(modalidade),
          ),
        ],
      ),
    );
  }
}
