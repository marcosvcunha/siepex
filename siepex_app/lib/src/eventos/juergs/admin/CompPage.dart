// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:siepex/models/modalidade.dart';
import 'package:provider/provider.dart';
import 'package:siepex/src/eventos/juergs/admin/ResultadosRustica.dart';
import 'package:siepex/src/eventos/juergs/admin/selectTeams.dart';
import 'package:siepex/src/eventos/juergs/admin/resultadosPage.dart';

/*
  Nessa página o ADM pode:
  - Passar a competição para próxima fase.
  - Selecionar os times para os jogos da próxima fase.
  - Mudar local da competição (a principio cada competição ocorre em apenas um lugar)
  - ? Alterar data limite de inscrição ?
 */
class CompetitionPage extends StatelessWidget {
  Widget nextFaseButton(BuildContext context, Modalidade modalidade) {
    if (modalidade.fase < 4) {
      return Align(
        alignment: Alignment.center,
        child: FlatButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider.value(
                          value: modalidade,
                          child: SelectTeamsPage(),
                        )));
          },
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Container(
            height: 45,
            width: 160,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(22)),
              boxShadow: [
                BoxShadow(
                    blurRadius: 2,
                    color: Colors.black87,
                    spreadRadius: 1,
                    offset: Offset(0, 2))
              ],
            ),
            child: Center(
              child: Text(
                'Avançar de Fase',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget lancarResultados(BuildContext context, Modalidade modalidade) {
    if (modalidade.fase < 4) {
      return Align(
        alignment: Alignment.center,
        child: FlatButton(
          onPressed: () {
            if (modalidade.nome != 'Rústica')
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider.value(
                            value: modalidade,
                            child: ResultadosPage(),
                          )));
            else
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider.value(
                  value: modalidade, 
                  child: ResultadosRustica(),
                  )));
          },
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Container(
            height: 45,
            width: 160,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(22)),
              boxShadow: [
                BoxShadow(
                    blurRadius: 2,
                    color: Colors.black87,
                    spreadRadius: 1,
                    offset: Offset(0, 2))
              ],
            ),
            child: Center(
              child: Text(
                'Lançar Resultados',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget selectButton1(context, Modalidade modalidade) {
    if (modalidade.nome != 'Rústica')
      return nextFaseButton(context, modalidade);
    else
      return Container();
  }

  @override
  Widget build(BuildContext context) {
    Modalidade modalidade = Provider.of<Modalidade>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Competição'),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(left: 22.0, top: 16),
          child: Text(
            modalidade.nome,
            style: TextStyle(
                color: Colors.black, fontSize: 26, fontWeight: FontWeight.w700),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 22, top: 12),
          child: Text(
            'Local da Competição:',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 22, top: 4),
          child: Text(
            'Rua Tanto Faz, número 332',
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 22, top: 12),
          child: Text(
            'Fase Atual:',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 22, top: 4),
          child: Text(
            modalidade.faseStr,
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 22, top: 12),
          child: Text(
            'Fim das inscrições:',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 22, top: 4),
          child: Text(
            modalidade.dataLimiteString,
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        selectButton1(context, modalidade),
        SizedBox(
          height: 40,
        ),
        lancarResultados(context, modalidade)
      ]),
    );
  }
}
