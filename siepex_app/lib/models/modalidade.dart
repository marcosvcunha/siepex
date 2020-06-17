import 'package:flutter/material.dart';
import 'package:siepex/icons/my_flutter_app_icons.dart';
import 'package:siepex/icons/sport_icons.dart';
import 'package:siepex/models/serializeJuergs.dart';


Map<String, Icon> icons = {
  'Futsal Masculino': Icon(MyFlutterApp.soccerBall, size: 50, color: Colors.black87,),
  'Futsal Feminino': Icon(MyFlutterApp.soccerBall, size: 50, color: Colors.black87,),
  'Rústica': Icon(Sport.runner, size: 50, color: Colors.black87,),
  'Vôlei Misto': Icon(Sport.volleyball_ball,size: 50, color: Colors.black87,),
  'Handebol Masculino': Icon(Sport.shot_putter, size: 50, color: Colors.black87,),
  'Handebol Feminino': Icon(Sport.shot_putter, size: 50, color: Colors.black87,),
  };
  

class Modalidade extends ChangeNotifier{
  int id;
  String nome;
  String dataLimiteString;
  DateTime dataLimite;
  int maxParticipantes; // # maximo por equipes
  bool _inscrito; // O usuario é inscrito nesta modalidade?
  Icon icon;

  get inscrito => _inscrito;

  set inscrito(bool newVal){
      _inscrito = newVal;
      print("Notificando modalidade");
      notifyListeners();
  }
  
  Modalidade(int modId, String modNome, int modMaxParticipantes, bool modInscrito, DateTime modDataLimite){
    id = modId;
    nome = modNome;
    maxParticipantes = modMaxParticipantes;
    _inscrito = modInscrito;
    icon = icons[nome];
    dataLimite = modDataLimite;
    dataLimiteString = '${dataLimite.day.toString()}/${dataLimite.month.toString()} ${dataLimite.hour.toString()}:${dataLimite.minute.toString()}';
  }
}