import 'package:flutter/material.dart';
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
  List<String> part;
  List<String> partCpf;
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
            itemCount: part.length,
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
                      Text(part[index], style: TextStyle(
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
                  confirmDialog(context, 'Mudar Capitão', 'Deseja confimar ' + part[selectedButton] + ' como novo capitão?', 
                  () async {
                    await equipe.changeCaptain(context, partCpf[selectedButton]);
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
    part = List<String>.from(equipe.participantesNomes);
    partCpf = List<String>.from(equipe.participantesCpf);
    part.remove(equipe.nomeCapitao);
    partCpf.remove(equipe.cpfCapitao);
    return Scaffold(
      appBar: AppBar(
        title: Text('Mudar Capitão'),
      ),
      body: equipe.isLoading ? Center(child: CircularProgressIndicator(),) : body(),
    );
  }
}