import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:siepex/icons/sport_icons.dart' as sportIcon;
import 'package:siepex/src/eventos/juergs/Widgets/roundButton.dart';
import 'package:siepex/src/eventos/juergs/equipe/changeCaptainPage.dart';
import '../Widgets/ColumnBuilder.dart';
import '../tabelas/widgets.dart';
import '../models/equipe.dart';
import 'package:siepex/models/serializeJuergs.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

class PaginaEquipe extends StatefulWidget {
  // final Equipe equipe;
  // PaginaEquipe({this.equipe});
  @override
  _PaginaEquipeState createState() => _PaginaEquipeState();
}

class _PaginaEquipeState extends State<PaginaEquipe> {
  bool isCap; // Diz se o User é Capitão
  bool isInTeam; // Diz se o User está nesta equipe
  bool temEquipe; // Diz se o User já tem equipe para esta modalidade.
  bool editName = false;
  TextEditingController nameController = TextEditingController();
  Equipe equipe;

  TextStyle txtStyle1(bool bold) {
    return TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: bold ? FontWeight.w600 : FontWeight.w400);
  }

  Widget selectButton() {
    if (isCap && isInTeam) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          roundButton('Alterar Capitão', Colors.green[700], Icons.swap_horiz, equipe.numeroParticipantes > 1 ? (){
            Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (BuildContext context) => ChangeNotifierProvider.value(value: equipe, child: ChangeCaptain()),
            ));
          } : null),
          SizedBox(
            width: 20,
          ),
          roundButton('Sair da Equipe', Colors.red, Icons.exit_to_app, null),
        ],
      );
    } else if (!temEquipe) {
      return roundButton('Entrar', Colors.green[700], Icons.arrow_forward, null);
    } else {
      return Container();
    }
  }

  Widget excludePartButton() {
    if (isCap && isInTeam) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: roundButton('Excluir Membro', Colors.red, Icons.arrow_upward, null),
      );
    } else {
      return Container();
    }
  }

  Widget nomeEquipe() {
    if (!editName)
      return Container(
        constraints: BoxConstraints(maxWidth: 235),
        child: Text(equipe.nome,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              color: Colors.blue[800],
              fontSize: 30,
              fontWeight: FontWeight.w600,
            )),
      );
    else
      return Container(
        width: 235,
        child: TextField(
          controller: nameController,
          textCapitalization: TextCapitalization.words,
          style: TextStyle(color: Colors.blue[800], fontSize: 30),
          autocorrect: false,
          enableSuggestions: false,
          decoration: InputDecoration(),
        ),
      );
  }

  Widget editButton() {
    if (isCap) {
      if (!editName) {
        return IconButton(
          onPressed: () => setState(() {
            editName = true;
          }),
          icon: Icon(
            Icons.edit,
            size: 28,
            color: Colors.green,
          ),
        );
      } else {
        return IconButton(
          onPressed: () async {
            await equipe.updateName(context, nameController.text);
            setState(() {
              editName = false;
            });
          },
          icon: Icon(
            Icons.done,
            size: 28,
            color: Colors.green,
          ),
        );
      }
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    equipe = Provider.of<Equipe>(context);
    isCap = equipe.cpfCapitao == userJuergs.cpf;
    isInTeam = userJuergs.isInTeam(equipe.id);
    temEquipe = userJuergs.temEquipe(equipe.nomeModalidade);
    nameController.text = equipe.nome;
    return Scaffold(
      appBar: AppBar(
        title: Text('Página da Equipe'),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    nomeEquipe(),
                    SizedBox(
                      width: 8,
                    ),
                    editButton(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 26.0,
                    top: 8,
                  ),
                  child: Icon(sportIcon.Sport.volleyball_ball,
                      color: Colors.deepPurple, size: 55),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, top: 16, bottom: 8),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Capitão: ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      equipe.nomeCapitao,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Contato: ', style: txtStyle1(true)),
                    Text(
                      equipe.celCapitaoFormated,
                      style: txtStyle1(false),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Modalidade: ', style: txtStyle1(true)),
                    Text(
                      equipe.nomeModalidade,
                      style: txtStyle1(false),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Participantes: ', style: txtStyle1(true)),
                    Text(
                      equipe.partFormat,
                      style: txtStyle1(false),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
          selectButton(),
          Divider(
            height: 30,
            color: Colors.black87,
            thickness: 1,
            indent: 60,
            endIndent: 60,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text(
              'Participantes',
              style: TextStyle(
                color: Colors.blue[800],
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40.0, top: 12),
            child: Container(
              width: double.infinity,
              child: ColumnBuilder(
                itemCount: equipe.numeroParticipantes,
                itemBuilder: (context, index) => Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        height: 7,
                        width: 7,
                        decoration: new BoxDecoration(
                          color: Colors.deepPurple[700],
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Text(
                      equipe.participantesNomes[index],
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      overflow: TextOverflow.fade,
                    ),
                  ],
                ),
              ),
            ),
          ),
          excludePartButton(),
          Divider(
            height: 30,
            color: Colors.black87,
            thickness: 1,
            indent: 60,
            endIndent: 60,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, bottom: 12),
            child: Text(
              'Jogos',
              style: TextStyle(
                color: Colors.blue[800],
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ColumnBuilder(
            itemCount: 6,
            itemBuilder: (context, index) => jogoCard(),
          ),
        ],
      ),
    );
  }
}
