import 'package:flutter/material.dart';
import 'package:siepex/icons/my_flutter_app_icons.dart';
import 'package:siepex/icons/sport_icons.dart';
import 'package:siepex/models/serializeJuergs.dart';


Map<String, IconData> icons = {
  'Futsal Masculino': MyFlutterApp.soccerBall,
  'Futsal Feminino': MyFlutterApp.soccerBall,
  'Rústica': Sport.runner,
  'Vôlei Misto': Sport.volleyball_ball,
  'Handebol Masculino': Sport.shot_putter,
  'Handebol Feminino': Sport.shot_putter,
  };

List<String> fases = [
  'Inscrição',
  'Fase de Grupos',
  'Quartas de Final',
  'Semi-Final',
  'Final',
];


class Modalidade extends ChangeNotifier{
  int id;
  String nome;
  String dataLimiteString;
  DateTime dataLimite;
  int maxParticipantes; // # maximo por equipes
  bool _inscrito; // O usuario é inscrito nesta modalidade?
  IconData icon;
  int fase;
  String faseStr;

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
    // TODO: Arrumar abaixo para pegar valores do DB.
    fase = 0;
    faseStr = fases[fase];
  }
}