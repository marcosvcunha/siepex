import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:siepex/models/modalidade.dart';
import 'package:siepex/src/eventos/juergs/Widgets/textinputdialog.dart';
import 'package:siepex/src/eventos/juergs/models/handledata.dart';

import 'models/equipe.dart';

class PaginaEquipes extends StatefulWidget {
  final Widget child;
  final Modalidade modalidade;
  PaginaEquipes({Key key, this.child, this.modalidade}) : super(key: key);

  @override
  _PaginaEquipesState createState() => _PaginaEquipesState();
}

class _PaginaEquipesState extends State<PaginaEquipes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Equipes da modalidade: ' + widget.modalidade.nome),
      ),
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      'assets/img/arte_uergs/Background_App_Uergs.png'),
                  fit: BoxFit.fill)),
          child: FutureBuilder(
            future: HandleData().getEquipes(widget.modalidade.id),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(backgroundColor: Colors.blue,),);
              }else{
                List<Equipe> equipesList = snapshot.data;
                if(snapshot.hasData){
                  return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index){
                    return ListTile(
                      title: Text(equipesList[index].nome),
                      subtitle: Text('Numero maximo de Participantes' + equipesList[index].maximoParticipantes.toString()),
                    );
                  });
                }else{
                  return Center(
                    child: Text('Nenhuma equipe cadastrada.', style: TextStyle(color: Colors.black),),
                  );
                }
              }
          }),
          ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(60))),
        height: 60,
        width: 80,
        child: SizedBox.expand(
          child: FlatButton(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () async {
                String nomeEquipe = await textInputDialog(context, widget.modalidade);
                await HandleData().criarEquipe(context, widget.modalidade, nomeEquipe);
                setState(() {
                });
              },
              child: Center(
                child: Text(
                  'Criar Equipe',
                  style: TextStyle(fontSize: 14), textAlign: TextAlign.center,
                ),
              )),
        ),
      ),
    );
  }
}
