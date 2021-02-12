import 'dart:convert';

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:siepex/models/modalidade.dart';
import 'package:siepex/models/serializeJuergs.dart';
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

  Future<List<Jogo>> listarJogos(Modalidade modalidade, int fase) async {
    var resposta =
        jsonDecode((await http.put(baseUrl + 'modalidades/listaTabela', body: {
      'idModalidade': modalidade.id.toString(),
      'etapa': fase.toString(),
    }))
            .body);
    List<Jogo> listaJogos = new List<Jogo>();

    if (resposta['status'] != null) {
      if (resposta['status'] == 'ok') {
        for (int i = 0; i != resposta['count']; i++) {
          Jogo jogosJuergs = new Jogo.fromJson(resposta['data'][i]);
          listaJogos.add(jogosJuergs);
        }
        return listaJogos;
      } else
        return [];
    } else {
      return [];
    }
  }

  Future<void> atualizaJogos(List<Jogo> jogos, BuildContext context) async {
    // Recebe uma lista de jogos de qualquer tamanho e envia os que foram editados (edited == true) ...
    // ... para a API atualizar os resultados

    List<Map<String, dynamic>> jogosJson = [];

    // await Future.delayed(Duration(seconds: 2));

    for (Jogo jogo in jogos) {
      if (jogo.edited) jogosJson.add(jogo.toJson());
    }
    if (jogosJson.length > 0) {
      try {
        var resposta =
          jsonDecode((await http.put(baseUrl + 'modalidades/atualizaJogos', body: {
        'jogos': json.encode(jogosJson),
      }))
              .body);
        if(resposta['status'] == 'sucesso'){
          Navigator.pop(context);
        }else{
          errorDialog(
            context, 'Erro!', 'Ocorreu um problema ao atualizar os jogos.');
        }
      } catch (e) {
        print('Um erro aconteceu ao atualizar os jogos: ' + e.toString());
        errorDialog(
            context, 'Erro!', 'Ocorreu um problema ao atualizar os jogos.');
      }
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
