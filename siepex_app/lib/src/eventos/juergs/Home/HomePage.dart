// import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:siepex/src/eventos/juergs/Widgets/ColumnBuilder.dart';
import 'package:siepex/src/eventos/juergs/models/equipe.dart';
import 'package:siepex/icons/my_flutter_app_icons.dart';
import 'package:siepex/icons/sport_icons.dart';
import 'package:siepex/src/eventos/juergs/models/jogo.dart';
import '../../../../models/serializeJuergs.dart';

Map<String, IconData> icons = {
  'Futsal Masculino': MyFlutterApp.soccerBall,
  'Futsal Feminino': MyFlutterApp.soccerBall,
  'Rústica': Sport.runner,
  'Vôlei Misto': Sport.volleyball_ball,
  'Handebol Masculino': Sport.shot_putter,
  'Handebol Feminino': Sport.shot_putter,
};

class HomePage extends StatelessWidget {

  final TabController tabController;

  HomePage({this.tabController});

  final TextStyle headerSyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Color(0xFF1E53C7),
  );

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

  Widget equipeMiniCard(Equipe equipe) {
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
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    equipe.nome,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
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
    );
  }

  Widget cardJogo(Jogo jogo) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        height: 80,
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
                    top: 12.0, bottom: 12, left: 12, right: 20),
                child: Container(
                  height: 80,
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
                                jogo.resultA.toString(),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              )
                            ]),
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
                                jogo.resultB.toString(),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              )
                            ]),
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
                child: Center(
                  child: Icon(icons['Futsal Masculino'],
                      size: 36, color: Color(0xff372554)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget corpoMinhasEquipes(List<Widget> cards) {
    if (cards.length > 0) {
      return Stack(
        children: [
          Wrap(
            children: cards,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 40,
              width: double.infinity,
              // color: Colors.red,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x00EEEEEE),
                      Color(0xB6EEEEEE),
                    ]),
              ),
            ),
          ),
        ],
      );
    }else{
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Você não participa de nenhuma equipe', style: TextStyle(fontSize: 16),),
            SizedBox(height: 8,),
            FlatButton(onPressed: (){
              tabController.index = 1;
            },
            focusColor: Colors.transparent,
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Text('Junte-se a uma', style: TextStyle(color: Colors.blue, fontSize: 20),))
          ],
        ),
        );
    }
  }

  Widget corpoMeusJogos(List<Jogo> jogos){
    if(jogos.length > 0){
      return Stack(
                      children: [
                        WrapBuilder(
                          itemBuilder: (context, index) =>
                              cardJogo(jogos[index]),
                          itemCount: 5,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 40,
                            width: double.infinity,
                            // color: Colors.red,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0x00EEEEEE),
                                    Color(0xB6EEEEEE),
                                  ]),
                            ),
                          ),
                        ),
                      ],
                    );
    }else{
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            'Você ainda não tem nenhum jogo marcado. Junte-se a uma equipe ou crie uma e aguarde a criação dos jogos.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
            ),
        ),
          );
    }
  }

  Widget corpo(List<Equipe> equipes, List<Jogo> jogos) {
    List<Widget> cards = List.generate(equipes.length, (index) {
      return equipeMiniCard(equipes[index]);
    });
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
                        Text(
                          'Minhas Equipes',
                          style: headerSyle,
                        ),
                        Text(
                          'Ver Mais',
                          style: TextStyle(color: Color(0xFF2C7AAD)),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Flexible(
                      child: corpoMinhasEquipes(cards),
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
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Meus Jogos',
                        style: headerSyle,
                      ),
                      Text(
                        'Ver Mais',
                        style: TextStyle(color: Color(0xFF2C7AAD)),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Flexible(
                    child: corpoMeusJogos(jogos),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<Map<String, dynamic>> getEquipesAndJogos(BuildContext context) async {
    List<Equipe> equipes = await Equipe.getMyEquipes(userJuergs.cpf);
    List<Jogo> jogos = await Jogo.pegarJogosUser(context);
    Map<String, dynamic> retorno = {'equipes': equipes, 'jogos': jogos};

    return retorno;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getEquipesAndJogos(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<Equipe> equipes = snapshot.data['equipes'];
            List<Jogo> jogos = snapshot.data['jogos'];
            return corpo(equipes, jogos);
          }
        });
  }
}
