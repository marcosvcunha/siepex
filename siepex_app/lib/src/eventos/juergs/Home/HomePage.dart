import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:siepex/src/eventos/juergs/Widgets/ColumnBuilder.dart';
import 'package:siepex/src/eventos/juergs/models/equipe.dart';

class HomePage extends StatelessWidget {
  TextStyle headerSyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Color(0xFF1E53C7),
  );

  Widget iconeParticipantes(){
    return Container(
      height: 34,
      width: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        color: Color(0xff95E1D3),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            child: Center(child: Text('10', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white))),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              color: Color(0xff75CDBD),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Icon(Icons.people, color: Color(0xff32695F),),
            ),
          )
        ],
      ),
    );
  }

  Widget equipeMiniCard(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        width: double.infinity,
        // height: 70,
        decoration: BoxDecoration(
          // color: Colors.red,
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Equipe Teste 1', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),),
                  iconeParticipantes(),
                ],
              ),
                Text('Futsal Masculino', style: TextStyle(fontSize: 16),)
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            width: double.infinity,
            // color: Colors.red,
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Minhas Equipes', style: headerSyle,),
                        Text('Ver Mais', style: TextStyle(color: Color(0xFF2C7AAD)),)
                      ],
                    ),
                    SizedBox(height: 12,),
                    Flexible(
                      child: WrapBuilder(
                       itemBuilder: (context, index) => equipeMiniCard(),
                       itemCount: 5,
                      ),
                    ),
                    ],
                ),
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            width: double.infinity,
            // color: Colors.blue,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text('Meus Jogos', style: headerSyle,)],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
