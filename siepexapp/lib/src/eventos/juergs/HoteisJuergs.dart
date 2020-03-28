import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class HoteisJuergs extends StatelessWidget {
  final Widget child;

  HoteisJuergs({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hotéis"),
      ),
      body: WebviewScaffold(
        url:
            'https://www.google.com.br/maps/search/Hot%C3%A9is/@-27.9510872,-51.8180865,15.75z/data=!4m8!2m7!3m6!1zSG90w6lpcw!2sUERGS+-+Sananduva+-+Av.+Fiorentino+Bachi,+311,+Sananduva+-+RS,+99840-000!3s0x94e24453fe571013:0x68f846a754ea475a!4m2!1d-51.8122811!2d-27.9515085',
      ),
    );
  }
}
