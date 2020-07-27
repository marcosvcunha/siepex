import 'package:flutter/material.dart';
import 'package:siepex/models/modalidade.dart';
import 'package:provider/provider.dart';
import 'package:siepex/src/eventos/juergs/Widgets/confirmDialog.dart';
import 'package:siepex/src/eventos/juergs/admin/listaEquipes.dart';
import '../Widgets/roundButton.dart';

/*
  Nesta página o ADM seleciona os times que vão para a próxima fase.
  O layout da página depende de qual é a próxima fase.
*/

class SelectTeamsPage extends StatefulWidget {

  @override
  _SelectTeamsPageState createState() => _SelectTeamsPageState();
}

class _SelectTeamsPageState extends State<SelectTeamsPage> {
  List<int> equipesGrupoId = List.generate(24, (index){return -2;});

  List<String> equipesGrupoNome = List.generate(24, (index){return 'Selecione';});

  Modalidade modalidade;

  bool allFilled(){
    for(int id in equipesGrupoId){
      if(id == -2)
       return false;
    }
      return true;
  }

  Widget gruposSelection() {
    List<String> groups = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
    // LISTA COM AS TABELAS
    return ListView.builder(
      itemCount: groups.length + 1,
      itemBuilder: (context, index){
        if(index < groups.length)
          return Column(
            children: <Widget>[
              grupoTable(context, groups[index], index*3),
              SizedBox(height: 20,),
            ],
          );
        else
        //  BOTÃO PARA CONFIMAR O ENVIO DOS TIMES
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: roundButton('Confimar', Colors.blue, Icons.thumb_up, (){
              if(allFilled()){
                confirmDialog(context, 'Finalizar', 'Confimar envio das equipes?', 
                (){
                  // TODO:: Enviar dados para a API
                  Navigator.pop(context);
                  Navigator.pop(context);
                }, 
                () => Navigator.pop(context)
                );
              }
              else
                Scaffold.of(context).showSnackBar(SnackBar(content: Text('Preencha todas as equipes!', ),));
            }),
          );
      });
  }

  Widget grupoTable(BuildContext context, String grupo, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: <Widget>[
          Align(
              alignment: Alignment.center,
              child: Text(
                'Grupo ' + grupo,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              )),
          Divider(color: Colors.black, indent: 20, thickness: 0.8, endIndent: 20,),
          grupoLinha(context, grupo + '1', index),
          grupoLinha(context, grupo + '2', index + 1),
          grupoLinha(context, grupo + '3', index + 2),
        ],
      ),
    );
  }

  Widget grupoLinha(BuildContext context, String time, int index){
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Time ' + time, style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),),
                Row(
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.edit, color: Colors.deepOrange, size: 22,), onPressed: () async {
                      List resul = await Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider.value(
                          value: modalidade, 
                          child: ListaEquipesPage(equipeId: time, equipesSelecionadas: equipesGrupoId),) ));
                      // TODO: colocar time na lista
                      if(resul != null){
                        equipesGrupoId[index] = resul[0];
                        equipesGrupoNome[index] = resul[1];
                        print(index);
                        setState(() {
                          
                        });
                      }
                    }),
                    Text(equipesGrupoNome[index], style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
                    overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )
              ],
            ),
          ),
          Divider(color: Colors.black, indent: 20, thickness: 0.8, endIndent: 20,),
      ]
    );
  }

Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Voltar', style: TextStyle(color: Colors.black),),
        content: new Text('Tem certeza que deseja retornar? As alterações serão perdidas.', style: TextStyle(color: Colors.black),),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('Nao'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Sim'),
          ),
        ],
      ),
    )) ?? false;
  }


  @override
  Widget build(BuildContext context) {
    modalidade = Provider.of<Modalidade>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
          child: Scaffold(
        appBar: AppBar(
          title: Text('Selecione as Equipes'),
        ),
        body: gruposSelection(),
      ),
    );
  }
}
