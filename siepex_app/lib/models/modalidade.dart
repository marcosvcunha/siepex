import 'package:flutter/material.dart';
import 'package:siepex/icons/my_flutter_app_icons.dart';


Map<String, Icon> icons = {
  'Futsal Masculino': Icon(MyFlutterApp.soccerBall, size: 65, color: Colors.black87,),
  'Futsal Feminino': Icon(MyFlutterApp.soccerBall, size: 65, color: Colors.black87,),
  'Rústica': Icon(Icons.people, size: 65, color: Colors.black87,),
  'Vôlei Misto': Icon(MyFlutterApp.soccerBall,size: 65, color: Colors.black87,),
  'Handebol Masculino': Icon(MyFlutterApp.soccerBall, size: 65, color: Colors.black87,),
  'Handebol Feminino': Icon(MyFlutterApp.soccerBall, size: 65, color: Colors.black87,),
  };
  

class Modalidade{
  int id;
  String nome;
  String dataLimiteString;
  DateTime dataLimite;
  int maxParticipantes; // # maximo por equipes
  bool inscrito;
  Icon icon;

  Modalidade(int modId, String modNome, int modMaxParticipantes, bool modInscrito, DateTime modDataLimite){
    id = modId;
    nome = modNome;
    maxParticipantes = modMaxParticipantes;
    inscrito = modInscrito;
    icon = icons[nome];
    dataLimite = modDataLimite;
    dataLimiteString = '${dataLimite.day.toString()}/${dataLimite.month.toString()} ${dataLimite.hour.toString()}:${dataLimite.minute.toString()}';
  }
}