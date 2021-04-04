import 'package:flutter/material.dart';
import 'package:siepex/src/eventos/juergs/models/modalidade.dart';
import 'package:siepex/src/eventos/juergs/Widgets/ColumnBuilder.dart';
import 'package:siepex/src/eventos/juergs/Widgets/confirmDialog.dart';
import 'package:siepex/src/eventos/juergs/Widgets/roundButton.dart';
import 'package:siepex/src/eventos/juergs/models/equipe.dart';
import 'package:provider/provider.dart';
import 'package:siepex/src/eventos/juergs/models/serializeJuergs.dart';

class ExcludeMemberPage extends StatefulWidget {
  @override
  _ExcludeMemberPageState createState() => _ExcludeMemberPageState();
}


class _ExcludeMemberPageState extends State<ExcludeMemberPage> {
  List<Estudante> participantes = <Estudante> [];
  Equipe equipe;
  List<bool> checkBoxValues = List.generate(30, (index) => false);

  Widget body(){
    return ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16),
            child: Text(
                'Selecione os membros que deseja excluir:',
                style: TextStyle(
                  color: Colors.blue[800],
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ),
          SizedBox(height: 16),
          ColumnBuilder(
            itemCount: participantes.length,
            itemBuilder: (context, index){
              return Container(
                height: 45,
                child: Center(
                  child: FlatButton(
                    onPressed: (){
                      checkBoxValues[index] = !checkBoxValues[index];
                            setState(() {
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        Checkbox(value: checkBoxValues[index], onChanged: (newVal){
                          setState(() {
                            checkBoxValues[index] = newVal;
                          });
                        },
                        ),
                      Text(participantes[index].nome, style: TextStyle(
                        color: checkBoxValues[index] ? Colors.blue : Colors.black87, fontSize: 22, fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                ),
              );
            }),
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                roundButton('Confimar', Colors.green, Icons.done, (){
                  String excludedMembers = '';
                  for(int i = 0; i < participantes.length; i++){
                    if(checkBoxValues[i]){
                      if(excludedMembers.length > 0)
                        excludedMembers += ', ';
                      excludedMembers += participantes[i].nome;
                    }
                  }
                  if(excludedMembers.length > 0)
                    excludedMembers += '.';
                  else
                    excludedMembers = 'Nenhum participante selecionado.';
                  confirmDialog(context, 'Excluir Membros', 'Confirmar exclusão dos seguintes membros: ' + excludedMembers, 
                  () async {
                    List<String> membersCpf = [];
                    for(int i = 0; i < participantes.length; i++){
                      if(checkBoxValues[i]){
                        membersCpf.add(participantes[i].cpf);
                      }
                    }
                    await equipe.excludeMembers(context, membersCpf);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }, (){
                    Navigator.of(context).pop();
                  });
                }),
                SizedBox(width: 20),
                roundButton('Cancelar', Colors.red, Icons.cancel, () => Navigator.pop(context))
              ],
            ),
        ],
      );
  }
  @override
  Widget build(BuildContext context) {
    equipe = Provider.of<Equipe>(context);
    participantes = List<Estudante>.from(equipe.participantes);
    participantes.removeWhere((element) => element.cpf == equipe.capitao.cpf);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mudar Capitão'),
      ),
      body: equipe.isLoading ? Center(child: CircularProgressIndicator(),) : body(),
    );
  }
}