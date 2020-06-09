import 'package:flutter/material.dart';
import './widgets.dart';

class TabelaFinal extends StatelessWidget {

  Widget _text(String text) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 22, color: Colors.black, fontWeight: FontWeight.w400),
    );
  }

  List<Widget> buildFinal() {
    return [
      Text(
        'Final',
        style: TextStyle(
            fontSize: 22, color: Colors.black, fontWeight: FontWeight.w400),
      ),
      jogoCard(),
      Text(
        '3º Lugar',
        style: TextStyle(
            fontSize: 22, color: Colors.black, fontWeight: FontWeight.w400),
      ),
      jogoCard(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.grey[400],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: buildFinal(),
      ),
    );
  }
}
