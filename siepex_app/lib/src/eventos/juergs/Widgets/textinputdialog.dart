import 'package:flutter/material.dart';
import 'package:siepex/models/modalidade.dart';
import 'package:siepex/src/eventos/juergs/Widgets/errorDialog.dart';
import 'package:siepex/src/eventos/juergs/models/handledata.dart';

void textInputDialog(BuildContext context, Modalidade modalidade){
  TextEditingController _controller = TextEditingController();
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Digite o nome da equipe:',
            style: TextStyle(color: Colors.black),
          ),
          content: TextField(
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(4),
                labelText: 'Nome da equipe',
                border: OutlineInputBorder()),
            style: TextStyle(color: Colors.black),
            controller: _controller,
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: (){
                  if (_controller.text.isEmpty) {
                    Navigator.pop(context);
                    errorDialog(context, 'Erro', 'Nome é obrigatorio');
                    return false;
                  } else {
                    HandleData()
                        .criarEquipe(context, modalidade, _controller.text);
                    Navigator.pop(context);
                    return true;
                  }
                },
                child: Text('Confimar')),
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  return false;
                },
                child: Text('Cancelar')),
          ],
        );
      });
}
