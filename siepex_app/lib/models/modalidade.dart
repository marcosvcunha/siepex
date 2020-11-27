import 'package:flutter/material.dart';
import 'package:siepex/icons/my_flutter_app_icons.dart';
import 'package:siepex/icons/sport_icons.dart';
import 'package:http/http.dart' as http;
import 'package:siepex/src/config.dart';
import 'dart:convert';
// import 'package:siepex/models/serializeJuergs.dart';

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
  'Finalisada',
];

class Modalidade extends ChangeNotifier {
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

  set inscrito(bool newVal) {
    _inscrito = newVal;
  }

  Modalidade(int modId, String modNome, int modMaxParticipantes,
      bool modInscrito, DateTime modDataLimite, int fase) {
    id = modId;
    nome = modNome;
    maxParticipantes = modMaxParticipantes;
    _inscrito = modInscrito;
    icon = icons[nome];
    dataLimite = modDataLimite;
    dataLimiteString =
        '${dataLimite.day.toString()}/${dataLimite.month.toString()} ${dataLimite.hour.toString()}:${dataLimite.minute.toString()}';
    this.fase = fase;
    faseStr = fases[fase];
  }

  Future<void> nextFase(List<int> idEquipes, List<String> equipesGrupoNome) async {
    idEquipes.removeWhere((item) => item == -2);
    equipesGrupoNome.removeWhere((item) => item == 'Selecione');
    var resposta =
            jsonDecode((await http.put(baseUrl + 'modalidades/nextFase', body: {
          'id_modalidade': id.toString(),
          'fase_atual': fase.toString(),
          'idEquipes': idEquipes.toString(),
          'equipesGrupoNome': equipesGrupoNome.toString(),
        })).body);
    if(resposta['status'] == 'sucesso'){
      // Alterar a fase nesta modalidade e dar NotifyListeners.
      this.fase += 1;
      notifyListeners();
      print('Sucesso');
    }else if(resposta['status'] == 'erro'){
      // TODO:: Conferir os possiveis erros
    }
  }
}
