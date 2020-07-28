import 'package:flutter/material.dart';

Widget loadingSnackbar(){
  return SnackBar(content: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text('Carregando'),
      CircularProgressIndicator(),
    ],
  ));
}