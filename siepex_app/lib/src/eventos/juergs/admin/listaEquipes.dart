import 'package:flutter/material.dart';
import 'package:siepex/src/eventos/juergs/models/modalidade.dart';
import 'package:siepex/src/eventos/juergs/models/equipe.dart';

class ListaEquipesPage extends StatelessWidget {
  final String equipeId;
  // Equipes que não devem ser disponibilizadas para seleção.
  final List<Equipe> equipesSelecionaveis;

  ListaEquipesPage(
      {@required this.equipeId, @required this.equipesSelecionaveis});

  Widget _equipeCard(BuildContext context, Equipe equipe) {
    return Padding(
      padding: EdgeInsets.only(top: 22, left: 32, right: 32),
      child: Container(
        // height: 200,
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF3498B7), Color(0xFF7db0a2)]),
          boxShadow: [
            BoxShadow(
                blurRadius: 2,
                spreadRadius: 1,
                color: Colors.black87,
                offset: Offset(0, 2))
          ],
        ),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  equipe.nome,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.w600),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Capitão: ' + equipe.capitao.nome,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Contato: ' + equipe.celCapitaoFormated,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Participantes: ${equipe.partFormat}',
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 2),
                    ajustaEquipe(equipe.index + 1, equipe.idModalidade),
                  ],
                ),
              ),
            ),
            // Botão de Selecionar
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                height: 46,
                width: 135,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: FlatButton(
                    onPressed: () {
                      // Retorna o id e nome da equipe selecionada
                      Navigator.pop(context, equipe);
                    },
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.done,
                            size: 26,
                            color: Colors.white,
                          ),
                          Expanded(
                            child: Text(
                              'Selecionar',
                              maxLines: 2,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Card para deixar equipe em branco
  Widget _blankCard(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 22, left: 32, right: 32),
      child: Container(
        // height: 200,
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF3498B7), Color(0xFF7db0a2)]),
          boxShadow: [
            BoxShadow(
                blurRadius: 2,
                spreadRadius: 1,
                color: Colors.black87,
                offset: Offset(0, 2))
          ],
        ),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Deixar em Branco',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            // Botão de Selecionar
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                height: 46,
                width: 135,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: FlatButton(
                    onPressed: () {
                      // Retorna o id e nome da equipe selecionada
                      Navigator.pop(context, null);
                    },
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.done,
                            size: 26,
                            color: Colors.white,
                          ),
                          Expanded(
                            child: Text(
                              'Selecionar',
                              maxLines: 2,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text ajustaEquipe(int index, int idModalidade) {
    if (idModalidade == 1 || idModalidade == 3) {
      if (index > 16) {
        return Text(
          'Equipe: ' + (index).toString() + '/16',
          style: TextStyle(
              color: Colors.red[900],
              fontSize: 16,
              fontWeight: FontWeight.w400),
        );
      } else {
        return Text(
          'Equipe: ' + (index).toString() + '/16',
          style: TextStyle(
              color: Colors.blueGrey[900],
              fontSize: 16,
              fontWeight: FontWeight.w400),
        );
      }
    } else if (idModalidade == 2) {
      if (index > 12) {
        return Text(
          'Equipe: ' + (index).toString() + '/12',
          style: TextStyle(
              color: Colors.red[900],
              fontSize: 16,
              fontWeight: FontWeight.w400),
        );
      } else {
        return Text(
          'Equipe: ' + (index).toString() + '/12',
          style: TextStyle(
              color: Colors.blueGrey[900],
              fontSize: 16,
              fontWeight: FontWeight.w400),
        );
      }
    } else if (idModalidade == 4 || idModalidade == 5) {
      if (index > 8) {
        return Text(
          'Equipe: ' + (index).toString() + '/8',
          style: TextStyle(
              color: Colors.red[900],
              fontSize: 16,
              fontWeight: FontWeight.w400),
        );
      } else {
        return Text(
          'Equipe: ' + (index).toString() + '/8',
          style: TextStyle(
              color: Colors.blueGrey[900],
              fontSize: 16,
              fontWeight: FontWeight.w400),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Modalidade _modalidade = Provider.of<Modalidade>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecione a equipe ' + equipeId),
      ),
      // body: Container(),
      body: ListView.builder(
          itemCount: equipesSelecionaveis.length + 1,
          itemBuilder: (context, index) {
            if (index < equipesSelecionaveis.length)
              return _equipeCard(context, equipesSelecionaveis[index]);
            else
              return _blankCard(context);
          }),
    );
  }
}
