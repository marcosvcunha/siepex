import 'package:flutter/material.dart';
// import 'package:faker/faker.dart';
import 'package:siepex/icons/sport_icons.dart' as sportIcon;
// import 'package:siepex/models/modalidade.dart';
import 'package:siepex/src/eventos/juergs/models/serializeJuergs.dart';
import 'package:siepex/src/eventos/juergs/models/modalidade.dart';
import 'package:siepex/src/eventos/juergs/Widgets/confirmDialog.dart';
import 'package:siepex/src/eventos/juergs/Widgets/roundButton.dart';
import 'package:siepex/src/eventos/juergs/equipe/changeCaptainPage.dart';
import 'package:siepex/src/eventos/juergs/equipe/excludeMemberPage.dart';
import 'package:siepex/src/eventos/juergs/models/jogo.dart';
import '../Widgets/ColumnBuilder.dart';
import '../tabelas/widgets.dart';
import '../models/equipe.dart';
// import 'package:siepex/models/serializeJuergs.dart';
import 'package:provider/provider.dart';
// import 'package:animations/animations.dart';


class PaginaEquipe extends StatelessWidget {
  bool isCap; // Diz se o User é Capitão
  bool isInTeam; // Diz se o User está nesta equipe
  bool temEquipe; // Diz se o User já tem equipe para esta modalidade.
  Equipe equipe;
  Modalidade modalidade;

  TextStyle txtStyle1(bool bold) {
    return TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: bold ? FontWeight.w600 : FontWeight.w400);
  }

  Widget selectButton(BuildContext context) {
    if (isCap && isInTeam) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          roundButton(
              'Alterar Capitão',
              Colors.green[700],
              Icons.swap_horiz,
              equipe.numeroParticipantes > 1
                  ? () {
                      Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            ChangeNotifierProvider.value(
                                value: equipe, child: ChangeCaptain()),
                      ));
                    }
                  : null),
          SizedBox(
            width: 20,
          ),
          roundButton('Sair da Equipe', Color(0xFFE23B43), Icons.exit_to_app, () {
            confirmDialog(context, 'Sair da equipe',
                'Tem certeza que deseja sair da equipe? A equipe será excluida por ficar sem capitão.',
                () async {
              print('Deletando Equipe');
              await equipe.deleteTeam(context);
              modalidade.inscrito = userJuergs.temEquipe(modalidade.nome);
              Navigator.pop(context);
              Navigator.pop(context);
            }, () {
              print('Cancelou');
              Navigator.pop(context);
            });
          }),
        ],
      );
    } else if (!temEquipe) {
      return roundButton(
          'Entrar', Colors.green[700], Icons.arrow_forward, () async {
            modalidade.notificar();
            equipe.entrarEquipe(context, modalidade.incricoesAbertas());
          });
    } else {
      return Container();
    }
  }

  Widget excludePartButton(BuildContext context) {
    if (isCap && isInTeam) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            roundButton('Excluir Membro',  Color(0xFFE23B43), Icons.arrow_upward, () {
          Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (BuildContext context) => ChangeNotifierProvider.value(
                value: equipe, child: ExcludeMemberPage()),
          ));
        }),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    equipe = Provider.of<Equipe>(context);
    modalidade = Provider.of<Modalidade>(context);
    isCap = equipe.capitao.cpf == userJuergs.cpf;
    isInTeam = userJuergs.isInTeam(equipe.id);
    temEquipe = userJuergs.temEquipe(equipe.nomeModalidade);
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
                NomeEquipe(),
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
                      equipe.capitao.nome,
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
                      equipe.capitao.celularString,
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
          selectButton(context),
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
                itemCount: equipe.participantes.length,
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
                      equipe.participantes[index].nome,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      overflow: TextOverflow.fade,
                    ),
                  ],
                ),
              ),
            ),
          ),
          excludePartButton(context),
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
          FutureBuilder(
            future: Jogo.pegarJogosPorEquipe(context, equipe.id),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 30),
                  child: CircularProgressIndicator(),
                );
              }else{
                if(snapshot.hasData){
                  List<Jogo> jogos = snapshot.data;
                  if(jogos.length == 0){
                    return Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Center(
                      child: Text('Nenhum jogo a mostrar', style: TextStyle(fontSize: 16, color: Color(0xFF808080)),),
                    ),
                    );
                  }else{
                    return ColumnBuilder(
                      itemCount: jogos.length,
                      itemBuilder: (context, index){
                        return jogoCard(jogos[index]);
                      }
                      );
                  
                  }
                }else{
                  return Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 30),
                    child: Text('Nada a mostrar', style: TextStyle(fontSize: 16, color: Color(0xFF808080)),),
                  );
                }
              }
          }),
          // ColumnBuilder(
          //   // TODO: Implementar para pegar os jogos reais!
          //   itemCount: 6,
          //   itemBuilder: (context, index) =>
          //       jogoCard(new Jogo('time A', 'time B', 0, 0, false, 'nome')),
          // ),
        ],
      ),
    );
  }
}

class NomeEquipe extends StatefulWidget {
  @override
  _NomeEquipeState createState() => _NomeEquipeState();
}

class _NomeEquipeState extends State<NomeEquipe> {
  Equipe equipe;

  bool editName = false;

  TextEditingController nameController = TextEditingController();

  bool isCap;

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
    isCap = equipe.capitao.cpf == userJuergs.cpf;
    nameController.text = equipe.nome;
    return Row(
      children: <Widget>[
        nomeEquipe(),
        SizedBox(
          width: 8,
        ),
        editButton(),
      ],
    );
  }
}
