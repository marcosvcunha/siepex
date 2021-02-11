import 'package:flutter/material.dart';
import 'package:siepex/models/serializeJuergs.dart';
// import 'package:animations/animations.dart';
import 'package:siepex/src/eventos/juergs/Widgets/ColumnBuilder.dart';
import 'package:siepex/src/eventos/juergs/Widgets/confirmDialog.dart';
import 'package:siepex/src/eventos/juergs/Widgets/roundButton.dart';
import 'package:siepex/src/eventos/juergs/models/equipe.dart';
import 'package:provider/provider.dart';
class ChangeCaptain extends StatefulWidget {
  // final Equipe equipe;
  // ChangeCaptain({this.equipe});
  @override
  _ChangeCaptainState createState() => _ChangeCaptainState();
}

class _ChangeCaptainState extends State<ChangeCaptain> {
  int selectedButton = 0;
  List<Estudante> participantes;
  Equipe equipe;

  Widget body(){
    return ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16),
            child: Text(
                'Escolha o novo capitão:',
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
                      selectedButton = index;
                            setState(() {
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        Radio(
                          value: index,
                          groupValue: selectedButton,
                          activeColor: Colors.blue,
                          onChanged: (val){
                            selectedButton = val;
                            setState(() {
                            });
                          },
                        ),
                      Text(participantes[index].nome, style: TextStyle(
                        color: selectedButton == index ? Colors.blue : Colors.black87, fontSize: 22, fontWeight: FontWeight.w400)),
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
                  confirmDialog(context, 'Mudar Capitão', 'Deseja confimar ' + participantes[selectedButton].nome + ' como novo capitão?', 
                  () async {
                    await equipe.changeCaptain(context, participantes[selectedButton]);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
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