import 'package:flutter/material.dart';
import 'package:siepex/models/modalidade.dart';
// import 'package:siepex/src/eventos/juergs/Widgets/errorDialog.dart';
// import 'package:siepex/src/eventos/juergs/models/handledata.dart';

Future<String> textInputDialog(
    BuildContext context, Modalidade modalidade) async {
  TextEditingController _controller = TextEditingController();
  String returlVal = await showDialog(
      context: context,
      barrierDismissible: false,
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
                onPressed: () {
                  Navigator.pop(context, _controller.text);
                },
                child: Text('Confimar')),
            FlatButton(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                child: Text('Cancelar')),
          ],
        );
      });
    return returlVal;
}
