import 'package:flutter/material.dart';
import 'package:siepex/models/modalidade.dart';
import 'package:siepex/src/eventos/juergs/models/jogo.dart';
import 'package:siepex/icons/my_flutter_app_icons.dart';
import 'package:siepex/icons/sport_icons.dart';

Map<String, IconData> icons = {
  'Futsal Masculino': MyFlutterApp.soccerBall,
  'Futsal Feminino': MyFlutterApp.soccerBall,
  'Rústica': Sport.runner,
  'Vôlei Misto': Sport.volleyball_ball,
  'Handebol Masculino': Sport.shot_putter,
  'Handebol Feminino': Sport.shot_putter,
};


class CardJogo extends StatelessWidget {
  final Jogo jogo;
  CardJogo({this.jogo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        // height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Flexible(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 12.0, bottom: 6, left: 12, right: 20),
                child: Container(
                  // height: 100,
                  // color: Colors.red,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  jogo.timeA,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              SizedBox(width: 16),
                              Text(
                                jogo.encerrado ? jogo.resultA.toString() : '-',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ]),
                        SizedBox(height: 8,),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  jogo.timeB,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              SizedBox(width: 16),
                              Text(
                                jogo.encerrado ? jogo.resultB.toString() : '-',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              )
                            ]),
                        SizedBox(height: 6,),
                            Text(jogo.encerrado ? 'Encerrado' : 'Não iniciou', style: TextStyle(color: Colors.grey[600]),)
                      ]),
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                height: 80,
                // color: Colors.blue,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      width: 3,
                      color: Color(0xFFDBDBDB),
                    ),
                  ),
                ),
                child: Container(
                  width: double.infinity,
                                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icons['Futsal Masculino'],
                          size: 36, color: Color(0xff372554)),
                      SizedBox(height: 4),
                      Text(
                        Modalidade.fases[int.parse(jogo.etapaJogo)],
                        overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}