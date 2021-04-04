import 'package:flutter/material.dart';
import 'package:siepex/src/eventos/juergs/models/modalidade.dart';
import 'package:siepex/src/eventos/juergs/equipe/PaginaEquipe.dart';
import 'package:siepex/src/eventos/juergs/models/equipe.dart';
import 'package:provider/provider.dart';

class EquipeMiniCard extends StatelessWidget {
  final Equipe equipe;
  EquipeMiniCard({this.equipe});

    Widget iconeParticipantes(int numParticipantes) {
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
            child: Center(
                child: Text(numParticipantes.toString(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white))),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              color: Color(0xff75CDBD),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Icon(
                Icons.people,
                color: Color(0xff32695F),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        child: FlatButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MultiProvider(providers: [
                          ChangeNotifierProvider.value(
                            value: equipe,
                          ),
                          ChangeNotifierProvider(
                              create: (context) => Modalidade()),
                        ], child: PaginaEquipe())));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      equipe.nome,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                    iconeParticipantes(equipe.participantes.length),
                  ],
                ),
                Text(
                  equipe.nomeModalidade,
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}