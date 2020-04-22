import 'package:flutter/material.dart';
import 'package:siepex/models/serializeJuergs.dart';
import 'package:siepex/src/eventos/juergs/InicioJuergs.dart';
import 'package:siepex/src/eventos/juergs/LoginPage.dart';
import 'package:provider/provider.dart';
import 'package:siepex/src/eventos/juergs/notifier/equipesnotifier.dart';

class AlternatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return userJuergs.isOn ? InicioJuergs() : LoginJuergs();
  }
}