import 'package:flutter/material.dart';
import 'package:siepex/models/modalidade.dart';
import 'package:provider/provider.dart';

class LancarResultadosPage extends StatefulWidget {
  // Página para lançar os resultados das Quartas, Semi ou Final.

  @override
  _LancarResultadosPageState createState() => _LancarResultadosPageState();
}

class _LancarResultadosPageState extends State<LancarResultadosPage> {
  @override
  Widget build(BuildContext context) {
    Modalidade modalidade = Provider.of<Modalidade>(context);
    print(modalidade.nome);
    print(modalidade.faseStr);
    return Scaffold(
      appBar: AppBar(
        title: Text('Lançar Resultados ' + modalidade.nome,
         overflow: TextOverflow.ellipsis,),
      ),
    );
  }
}
