import 'package:flutter/material.dart';
import 'package:siepex/icons/my_flutter_app_icons.dart';


Map<String, Icon> icons = {
  'Futsal Masculino': Icon(MyFlutterApp.soccerBall, size: 65, color: Colors.black87,),
  'Futsal Feminino': Icon(MyFlutterApp.soccerBall, size: 65, color: Colors.black87,),
  'Rústica': Icon(Icons.people, size: 65, color: Colors.black87,),
  'Vôlei Misto': Icon(MyFlutterApp.soccerBall, size: 65, color: Colors.black87,),
  'Handebol Masculino': Icon(MyFlutterApp.soccerBall, size: 65, color: Colors.black87,),
  'Handebol Feminino': Icon(MyFlutterApp.soccerBall, size: 65, color: Colors.black87,),
  };
  

class Modalidade{
  int id;
  String nome;
  int maxParticipantes; // # maximo por equipes
  bool inscrito;
  Icon icon;

  Modalidade(int modId, String modNome, int modMaxParticipantes, bool modInscrito){
    id = modId;
    nome = modNome;
    maxParticipantes = modMaxParticipantes;
    inscrito = modInscrito;
    icon = icons[nome];
  }
}