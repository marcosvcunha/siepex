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