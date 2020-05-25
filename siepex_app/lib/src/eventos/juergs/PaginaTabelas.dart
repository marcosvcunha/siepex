import 'package:flutter/material.dart';
import 'package:siepex/icons/sport_icons.dart';

class PaginaTabelas extends StatelessWidget {
  Widget competicaoButton(BuildContext context, IconData icone, String comp, String fase){
    return Container(
              //color: Colors.blue,
              height: 65,
              child: ListTile(
                leading: Icon(icone, size: 35, color: Color(0xff372554)),
                title: Text(comp, style: TextStyle(fontSize: 22, color: Colors.black87, fontWeight: FontWeight.w600),),
                subtitle: Text(fase, style: TextStyle(color: Colors.black87),),
                onTap: () => Navigator.pushNamed(context, 'tabelaPage'),
              ),
            );
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 3,
        shadowColor: Colors.black,
              child: Container(
          //height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey[100],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 12),
                child: Text('Competições', style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.w600),),
              ),
              competicaoButton(context, Sport.soccer_ball, 'Futsal Masculino', '1ª Fase'),
              competicaoButton(context, Sport.soccer_ball,'Futsal Feminino', '2ª Fase'),
              competicaoButton(context, Sport.volleyball_ball, 'Voleybol', 'Final'),
              competicaoButton(context, Sport.shot_putter, 'Handbol Masculino', 'Semi-final'),
              competicaoButton(context, Sport.shot_putter, 'Handbol Feminino', 'Quartas de final'),
            ],
          ),
        ),
      ),
    );
  }
}