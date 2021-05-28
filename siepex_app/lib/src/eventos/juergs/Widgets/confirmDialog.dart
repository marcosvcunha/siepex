 import 'package:flutter/material.dart';

void confirmDialog(BuildContext context, String title, String body, Function onConfirm, Function onCancel) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title, style: TextStyle(color: Colors.black),),
          content: new Text(body, style: TextStyle(color: Colors.black54),),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Confirmar",),
              onPressed: onConfirm,
            ),
            new FlatButton(
              child: new Text("Cancelar"),
              onPressed: onCancel,
            ),
          ],
        );
      },
    );
  }

Future<bool> confirmDialogWithReturn(BuildContext context, String title, String text) async {
    return await showDialog(
      barrierDismissible: false,
      context: context,

      builder:(_) => AlertDialog(
        title: Text(title),
        content: Text(
            text),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('Sim')),
          FlatButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('Não')),
        ],
      ),
    );
  }