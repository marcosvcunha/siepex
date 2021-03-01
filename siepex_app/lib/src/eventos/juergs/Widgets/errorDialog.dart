import 'package:flutter/material.dart';

void errorDialog(BuildContext context, String title, String error) async {
  await showDialog(
    context: context,
    builder: (context){
      return AlertDialog(

        title: Text(title, style: TextStyle(color: Colors.black),),
        content: Text(error, style: TextStyle(color: Colors.grey[700]),),
        actions: <Widget>[
          FlatButton(onPressed: () => Navigator.pop(context), 
          child: Text('Ok')),
        ],
      );
    }
    );
}