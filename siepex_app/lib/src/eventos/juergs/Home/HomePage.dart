// import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:siepex/src/eventos/juergs/models/modalidade.dart';
import 'package:siepex/src/eventos/juergs/JogosPage.dart';
import 'package:siepex/src/eventos/juergs/MinhasEquipesPage.dart';
import 'package:siepex/src/eventos/juergs/Widgets/CardJogo.dart';
import 'package:siepex/src/eventos/juergs/Widgets/ColumnBuilder.dart';
import 'package:siepex/src/eventos/juergs/Widgets/EquipeMiniCard.dart';
import 'package:siepex/src/eventos/juergs/equipe/PaginaEquipe.dart';
import 'package:siepex/src/eventos/juergs/models/equipe.dart';
import 'package:siepex/src/eventos/juergs/models/jogo.dart';
// import '../../../../models/serializeJuergs.dart';
import 'package:provider/provider.dart';
import 'package:siepex/src/eventos/juergs/models/serializeJuergs.dart';


class HomePage extends StatelessWidget {
  final TabController tabController;
  HomePage({this.tabController});

  final TextStyle headerSyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Color(0xFF1E53C7),
  );

  Widget corpoMinhasEquipes(List<Widget> cards) {
    if (cards.length > 0) {
      return Wrap(
        children: cards,
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
      return WrapBuilder(
          itemBuilder: (context, index) => CardJogo(jogo: jogos[index]),
          itemCount: jogos.length);
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
      return EquipeMiniCard(equipe: equipes[index]);
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
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => MinhasEquipesPage(),
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
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
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
