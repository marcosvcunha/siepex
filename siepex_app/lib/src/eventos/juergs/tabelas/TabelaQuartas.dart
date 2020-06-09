import 'package:flutter/material.dart';
import './widgets.dart';

class TabelaQuartas extends StatelessWidget {

  Widget _text(String text) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 22, color: Colors.black, fontWeight: FontWeight.w400),
    );
  }

  List<Widget> buildQuartas() {
    return [
      _text('Quartas 1'),
      jogoCard(),
      _text('Quartas 2'),
      jogoCard(),
      _text('Quartas 3'),
      jogoCard(),
      _text('Quartas 4'),
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
        children: buildQuartas(),
      ),
    );
  }
}
