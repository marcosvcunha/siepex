import 'package:flutter/material.dart';

List<Widget> createTextListFromStrings (List<String> nomes, int indexCapitao){
  List<Widget> widgetList = [];
  for(int i = 0; i < nomes.length; i++){
    if(i == indexCapitao){
      widgetList.add(Padding(
          padding: const EdgeInsets.only(left: 32),
          child: Row(
            children: <Widget>[
              Text(nomes[i], style: TextStyle(color:Colors.black, fontSize: 18)),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(Icons.star, size: 20, color: Colors.deepPurple,),
              ),
            ],
          ),
        ),);
    } else{
    widgetList.add(Padding(
          padding: const EdgeInsets.only(left: 32),
          child: Text(nomes[i], style: TextStyle(color:Colors.black, fontSize: 18)),
        ),);
    }
  }
  return widgetList;
}

void participantesDialog(BuildContext context, List<String> nomes, int indexCapitao){
  showDialog(context: context,
  builder: (context){
    return AlertDialog(
      title: Text('Participantes:', style: TextStyle(color:Colors.black),),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: createTextListFromStrings(nomes, indexCapitao)),
      actions: <Widget>[
        FlatButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text('Ok')),
      ],
    );
  });
}