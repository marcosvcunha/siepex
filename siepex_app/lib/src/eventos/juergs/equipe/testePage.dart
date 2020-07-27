import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siepex/models/modalidade.dart';
import 'package:siepex/src/eventos/juergs/models/equipe.dart';

class TestePage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    print('TestePage Build');
    Equipe _equipe = Provider.of<Equipe>(context);
    Modalidade _modalidade = Provider.of<Modalidade>(context);
    return Scaffold(
      appBar: AppBar(
        
      ),
      body: Center(
        child: Text('_equipe.nome', style: TextStyle(color: Colors.black, fontSize: 24),),
      ),
    );
  }
}