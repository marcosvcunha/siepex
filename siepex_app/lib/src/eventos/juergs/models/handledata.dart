import 'dart:convert';

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:siepex/src/eventos/juergs/models/modalidade.dart';
import 'package:siepex/src/eventos/juergs/models/serializeJuergs.dart';
import 'package:siepex/src/eventos/juergs/Widgets/errorDialog.dart';
import 'package:siepex/src/eventos/juergs/models/ParticipanteRustica.dart';
import 'package:siepex/src/eventos/juergs/models/equipe.dart';
import 'package:http/http.dart' as http;
import 'package:siepex/src/config.dart';
import 'package:siepex/src/eventos/juergs/models/jogo.dart';
import 'package:siepex/src/eventos/juergs/tabelas/TabelaGrupos.dart';

// HandleData possui metodos que interagem com a API
class HandleData {
  // Aqui vai pegar os dados do DB e retornar uma lista com as modalidades

  Future<List<ParticipanteRustica>> getParticipantesRustica() async {
    print('pegando participantes rústica');
    try {
      var resposta =
          jsonDecode((await http.get(baseUrl + 'obtemEquipes/rustica')).body);
      List<ParticipanteRustica> participantes = [];
      for (var jsonData in resposta['data']) {
        ParticipanteRustica participante = new ParticipanteRustica(jsonData);
        participantes.add(participante);
      }
      return participantes;
    } catch (e) {
      print(e);
      print("Erro ao obter participantes da rústica");
      return [];
    }
  }

  Future participarRustica(BuildContext context) async {
    // TODO: Conferir se as incrições ainda estão ativas
    try {
      if (!(userJuergs.tipoParticipante == "Atleta")) {
        errorDialog(context, 'Erro', 'Apenas Atletas podem criar equipes!');
        return;
      } else {
        var resposta = jsonDecode(
            (await http.put(baseUrl + 'equipe/cadastraRustica', body: {
          'nome': userJuergs.nome,
          'celular': userJuergs.celular,
          'cpf': userJuergs.cpf,
          'unidade': userJuergs.campoUergs,
        }))
                .body);

        if (resposta['status'] == 'sucesso') {
        } else if (resposta['erro'] == 'participante cadastrado') {
          errorDialog(context, 'Erro', 'Você já está incrito na modalidade.');
        } else {
          errorDialog(context, 'Erro', 'Um erro desconhecido ocorreu.');
        }
      }
    } catch (e) {
      print(e);
      errorDialog(context, 'Erro', 'Erro ao se inscrever na rústica!');
    }
  }

  Future updateRustica(
      BuildContext context, List<ParticipanteRustica> participantes) async {
    try {
      List<Map<String, dynamic>> partsJson = List.generate(
          participantes.length, (index) => participantes[index].toJson());
      // Map<String, String> headers = {
      //   'Content-Type': 'application/json;charset=UTF-8',
      //   'Charset': 'utf-8'
      // };
      var resposta =
          jsonDecode((await http.put(baseUrl + 'equipe/updateRustica', body: {
        'data': json.encode(partsJson),
      }))
              .body);
      if (resposta['status'] == 'sucesso')
        return;
      else
        errorDialog(context, 'Erro', 'Aconteceu um problema desconhecido!');
      return;
    } catch (e) {
      print('Erro: ' + e.toString());
      errorDialog(context, 'Erro', 'Aconteceu um problema desconhecido!');
    }
  }




  // static Future<List<Jogo>> getJogos(Modalidade modalidade) async {
  //   var resposta =
  //     jsonDecode((await http.put(baseUrl + 'modalidades/listaTabela', body: {
  //   'idModalidade': modalidade.id.toString(),
  //   'etapa': fase.toString(),
  // }))
  //         .body);
  // return [];
  // }
}
