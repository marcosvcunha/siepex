import 'package:flutter/material.dart';
import 'package:siepex/icons/my_flutter_app_icons.dart';
import 'package:siepex/icons/sport_icons.dart';
import 'package:http/http.dart' as http;
import 'package:siepex/src/config.dart';
import 'package:siepex/src/eventos/juergs/Widgets/errorDialog.dart';
import 'dart:convert';

import 'package:siepex/src/eventos/juergs/models/equipe.dart';
// import 'package:siepex/models/serializeJuergs.dart';

class Modalidade extends ChangeNotifier {
  int id;
  String nome;
  String dataLimiteString;
  DateTime dataLimite;
  int maxParticipantes; // # maximo por equipes
  bool _inscrito; // O usuario é inscrito nesta modalidade?
  IconData icon;
  int fase;
  // String faseStr;
  String _local;

  int _formatoCompeticao;
  // Formatos:
  // 1 - 32 times (8 grupos de 4) -> oitavas -> quartas -> semi -> final
  // 2 - 24 times (8 grupos de 3) -> quartas -> semi -> final
  // 3 - 16 times (4 grupos de 4) -> quartas -> semi -> final
  // 4 - 12 times (4 grupos de 3) -> semi -> final

  static Map<int, String> formatoDescricaoMap = {
    1: 'Fase de grupos com 32 times (8 grupos de 4 times). Dois de cada grupo passam às oitavas de final.',
    2: 'Fase de grupos com 24 times (8 grupos de 3 times). Um de cada grupo passa às quartas de final.',
    3: 'Fase de grupos com 16 times (4 grupos de 4 times). Dois de cada grupo passam às quartas de final.',
    4: 'Fase de grupos com 12 times (4 grupos de 3 times). Um de cada grupo passa à semi-final.'
  };

  static Map<int, int> formatoNumTimes = {
    1: 32,
    2: 24,
    3: 16,
    4: 12,
  };

  static Map<String, IconData> icons = {
    'Futsal Masculino': MyFlutterApp.soccerBall,
    'Futsal Feminino': MyFlutterApp.soccerBall,
    'Rústica': Sport.runner,
    'Vôlei Misto': Sport.volleyball_ball,
    'Handebol Masculino': Sport.shot_putter,
    'Handebol Feminino': Sport.shot_putter,
  };

  static List<String> fases = [
    'Inscrição',
    'Fase de Grupos',
    'Quartas de Final',
    'Semi-Final',
    'Final',
    'Finalizada',
  ];

  static Map<String, int> fasesMap = {
    'Inscrição': 0,
    'Fase de Grupos': 1,
    'Quartas de Final': 2,
    'Semi-Final': 3,
    'Final': 4,
    'Finalizada': 5,
  };

  int get formatoCompeticao {
    return formatoNumTimes[_formatoCompeticao];
  }

  String get formatoDescricao {
    return formatoDescricaoMap[_formatoCompeticao];
  }

  String get faseStr {
    return fases[fase];
  }

  get inscrito => _inscrito;

  set inscrito(bool newVal) {
    if (newVal != _inscrito) {
      _inscrito = newVal;
      notifyListeners();
    }
  }

  set local(String novoLocal) {
    if (novoLocal != _local) {
      _local = novoLocal;
      notifyListeners();
    }
  }

  get local {
    return _local;
  }

  void notificar() {
    // Gambiarra
    notifyListeners();
    // Utilizado para que a página de Equipes atualize quando o usuário entra numa equipe.
  }

  Modalidade() {}

  Modalidade.fromJson(jsonData) {
    id = jsonData['id'];
    nome = jsonData['nome_modalidade'];
    local = jsonData['endereco'];
    maxParticipantes = jsonData['maximo_participantes'];
    dataLimite = DateTime.parse(jsonData['limit_date']);
    _inscrito = false;
    fase = jsonData['fase'];
    icon = icons[nome];
    dataLimiteString =
        '${dataLimite.day.toString()}/${dataLimite.month.toString()} ${dataLimite.hour.toString()}:${dataLimite.minute.toString()}';
    _formatoCompeticao = jsonData['formatoCompeticao'];
  }

  Future<void> nextFase(BuildContext context, List<Equipe> equipes) async {
    // idEquipes.removeWhere((item) => item == -2);
    // equipesGrupoNome.removeWhere((item) => item == 'Selecione');
    try {
      List<int> idEquipes = <int>[];
      List<String> equipesNome = <String>[];
      for (Equipe equipe in equipes) {
        idEquipes.add(equipe.id);
        equipesNome.add(equipe.nome);
      }

      var resposta =
          jsonDecode((await http.put(baseUrl + 'modalidades/nextFase', body: {
        'id_modalidade': id.toString(),
        'fase_atual': fase.toString(),
        'idEquipes': idEquipes.toString(),
        'equipesGrupoNome': json.encode(equipesNome),
      }))
              .body);
      if (resposta['status'] == 'sucesso') {
        // Alterar a fase nesta modalidade e dar NotifyListeners.
        this.fase++;
        notifyListeners();
      } else if (resposta['status'] == 'erro') {
        // TODO:: Conferir os possiveis erros
        if (resposta['erro'] == 'jogos nao encerrados') {
          print('AQUI!');
          errorDialog(context, 'Erro!',
              'Alguns dos jogos ainda não foram encerrados ou não tiveram seus resultados lançados');
        }
      } else {
        errorDialog(context, 'Erro!', 'Ocorreu um problema desconhecido.');
      }
    } catch (e) {
      errorDialog(context, 'Erro!', 'Ocorreu um problema desconhecido.');
    }
  }

  bool incricoesAbertas() {
    return dataLimite.isAfter(DateTime.now());
  }

  Future changeLocal(BuildContext context, String novoLocal) async {
    try {
      var resposta = jsonDecode((await http.put(
              baseUrl + 'modalidades/changeLocal',
              body: {'id_modalidade': id.toString(), 'novo_local': novoLocal}))
          .body);

      if (resposta['status'] == 'sucesso') {
        local = novoLocal;
      } else {
        errorDialog(context, 'Erro!',
            'Um problema ocorreu ao tentar alterar o local da competição.');
      }
    } catch (e) {
      print(e);
      errorDialog(context, 'Erro!',
          'Um problema ocorreu ao tentar alterar o local da competição.');
    }
  }

  static Future<List<Modalidade>> getModalidades() async {
    try {
      var resposta = jsonDecode((await http.put(
        baseUrl + 'modalidades/getAll',
      ))
          .body);
      List<Modalidade> listaModalidade = new List<Modalidade>();
      if (resposta['status'] != null) {
        if (resposta['status'] == 'ok') {
          for (var i = 0; i != resposta['count']; i++) {
            Modalidade modalidade =
                new Modalidade.fromJson(resposta['data'][i]);
            listaModalidade.add(modalidade);
          }
        } else if (resposta['status'] == 'nao_achou') {
          print("nao deu");
        }
      }
      return listaModalidade;
    } catch (e) {
      print('Erro');
      return [];
    }
  }

  Future<bool> alterarFormato(int novoFormato) async {
    try {
      if (novoFormato != _formatoCompeticao) {
        var resposta = jsonDecode(
            (await http.put(baseUrl + 'modalidades/alterarFormato', body: {
          'id_modalidade': id.toString(),
          'novo_formato': novoFormato.toString(),
        }))
                .body);

        if (resposta['status'] == 'sucesso') {
          _formatoCompeticao = novoFormato;
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
