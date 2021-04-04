import 'package:flutter/material.dart';
import 'package:siepex/src/eventos/juergs/models/serializeJuergs.dart';
import 'package:siepex/src/eventos/juergs/Home/InicioJuergs.dart';
import 'package:siepex/src/eventos/juergs/LoginPage.dart';

class AlternatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return userJuergs.isOn ? InicioJuergs() : LoginJuergs();
  }
}