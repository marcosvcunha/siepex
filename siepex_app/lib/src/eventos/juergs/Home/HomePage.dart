// import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:siepex/models/modalidade.dart';
import 'package:siepex/src/eventos/juergs/JogosPage.dart';
import 'package:siepex/src/eventos/juergs/Widgets/CardJogo.dart';
import 'package:siepex/src/eventos/juergs/Widgets/ColumnBuilder.dart';
import 'package:siepex/src/eventos/juergs/equipe/PaginaEquipe.dart';
import 'package:siepex/src/eventos/juergs/models/equipe.dart';
import 'package:siepex/src/eventos/juergs/models/jogo.dart';
import '../../../../models/serializeJuergs.dart';
import 'package:provider/provider.dart';

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

  Widget equipeMiniCard(BuildContext context, Equipe equipe) {
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
                      Color(0xFFEEEEEE),
                    ]),
              ),
            ),
          ),
        ],
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Você não participa de nenhuma equipe',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 8,
            ),
            FlatButton(
                onPressed: () {
                  tabController.index = 1;
                },
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Text(
                  'Junte-se a uma',
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ))
          ],
        ),
      );
    }
  }

  Widget corpoMeusJogos(List<Jogo> jogos) {
    if (jogos.length > 0) {
      return Stack(
        children: [
          WrapBuilder(
              itemBuilder: (context, index) => CardJogo(jogo: jogos[index]),
              itemCount: jogos.length),
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
                      Color(0xFFEEEEEE),
                    ]),
              ),
            ),
          ),
        ],
      );
    } else {
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

  Widget corpo(BuildContext context, List<Equipe> equipes, List<Jogo> jogos) {
    List<Widget> cards = List.generate(equipes.length, (index) {
      return equipeMiniCard(context, equipes[index]);
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
                        FlatButton(
                          padding: EdgeInsets.zero,
	                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: (){
                          },
                          child: Text(
                            'Ver Mais',
                            style: TextStyle(color: Color(0xFF2C7AAD)),
                          ),
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
                      FlatButton(
                          padding: EdgeInsets.zero,
	                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => JogosPage(),
                              ));
                          },
                          child: Text(
                            'Ver Mais',
                            style: TextStyle(color: Color(0xFF2C7AAD)),
                          ),
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
            return corpo(context, equipes, jogos);
          }
        });
  }
}
