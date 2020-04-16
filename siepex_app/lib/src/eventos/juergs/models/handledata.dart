import 'dart:convert';

import 'dart:async';
import 'package:siepex/models/modalidade.dart';
import 'package:siepex/src/eventos/juergs/models/equipe.dart';
import 'package:http/http.dart' as http;
import 'package:siepex/src/config.dart';

class HandleData {
  // Aqui vai pegar os dados do DB e retornar uma lista com as modalidades
  Future<List<Modalidade>> getModalidades() async {
    await Future.delayed(Duration(seconds: 2)); // Delay
    try {
      var resposta = jsonDecode((await http.put(
        baseUrl + 'obtemModalidade/',
      ))
          .body);
      List<Modalidade> listaModalidade = new List<Modalidade>();
      if (resposta['status'] != null) {
        if (resposta['status'] == 'ok') {
          for (var i = 0; i != resposta['count']; i++) {
            Modalidade modalidade = new Modalidade(resposta['data'][i]['id'], resposta['data'][i]['nome_modalidade'], int.tryParse(resposta['data'][i]['maximo_participantes'].toString()), false);
            listaModalidade.add(modalidade);
          }
        } else if (resposta['status'] == 'nao_achou') {
          print("nao deu");
        }
      }
      return listaModalidade;
    } catch (e) {
      print(e);
      List<Modalidade> modalidades = [
        Modalidade(0, 'Ciclismo', 5, true),
      ];
      return modalidades;
    }
  }

  // Pega as equipes registradas para a modalidade.
  Future<List<Equipe>> getEquipes(int idModalidade) {
    return null;
  }
}
