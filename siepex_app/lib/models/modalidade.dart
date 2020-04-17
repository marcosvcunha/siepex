import 'package:flutter/material.dart';
import 'package:siepex/icons/my_flutter_app_icons.dart';


Map<String, Icon> icons = {
  'Futebol de salão': Icon(MyFlutterApp.soccerBall, size: 65, color: Colors.black87,),
  'Ufc': Icon(Icons.people, size: 65, color: Colors.black87,),
  'Vôlei': Icon(MyFlutterApp.soccerBall, size: 65, color: Colors.black87,),
  'Ciclismo': Icon(MyFlutterApp.cyclist, size: 65, color: Colors.black87,),
  'Ping Pong': Icon(MyFlutterApp.pingPong, size: 60, color: Colors.black87,),
  'Futebol': Icon(MyFlutterApp.soccerBall, size: 40, color: Colors.black87,),
  'Natação': Icon(MyFlutterApp.swimmer, size: 60, color: Colors.black87,),};
  

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