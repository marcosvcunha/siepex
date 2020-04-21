import 'package:flutter/material.dart';

List<Widget> createTextListFromStrings (List<String> nomes){
  List<Widget> widgetList = [];
  for(int i = 0; i < nomes.length; i++){
    widgetList.add(Padding(
          padding: const EdgeInsets.only(left: 32),
          child: Text(nomes[i], style: TextStyle(color:Colors.black, fontSize: 18)),
        ),);
  }
  return widgetList;
}

void participantesDialog(BuildContext context, List<String> nomes){
  showDialog(context: context,
  builder: (context){
    return AlertDialog(
      title: Text('Participantes:', style: TextStyle(color:Colors.black),),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: createTextListFromStrings(nomes)),
      actions: <Widget>[
        FlatButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text('Ok')),
      ],
    );
  });
}