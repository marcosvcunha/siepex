import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:siepex/src/eventos/juergs/models/modalidade.dart';
import 'package:siepex/src/eventos/juergs/models/serializeJuergs.dart';
import 'package:siepex/src/config.dart';
import 'package:siepex/src/eventos/juergs/Widgets/errorDialog.dart';
import 'package:siepex/src/eventos/juergs/models/equipe.dart';


class Jogo {
  String timeA;
  String timeB;
  int idJogo;
  int resultA;
  int resultB;
  bool encerrado;
  String nome; // Nome do jogo. Ex: Jogo 1, Jogo 2, ...
  bool
      edited; // Indica se o resultado foi alterado. (Utilizado no lançamento de resultados)
  bool beeingEdited =
      false; // Para saber se o resultado está sendo editado. (Utilizado no lançamento de resultados)

  int idTimeA;
  int idTimeB;
  int classModalidade;
  String etapaJogo;
  String local;

  get resultAStr {
    if (encerrado)
      return resultA.toString();
    else
      return '-';
  }

  get resultBStr {
    if (encerrado)
      return resultB.toString();
    else
      return '-';
  }

  get fase{
    
  }

  Jogo.fromJson(Map<String, dynamic> json) {
    this.timeA = json['time_a'];
    this.timeB = json['time_b'];
    this.idTimeA = json['id_time_a'];
    this.idTimeB = json['id_time_b'];
    this.resultA = json['resultado_a'];
    this.resultB = json['resultado_b'];
    this.encerrado = json['encerrado'];
    this.classModalidade = json['modalidade'];
    this.etapaJogo = json['etapa_jogo'];
    this.nome = 'Jogo';
    this.idJogo = json['id'];
    this.edited = false;
    this.local = json['local_jogo'];
  }

  Jogo(String timeA, String timeB, int resultA, int resultB, bool encerrado,
      String nome) {
    this.timeA = timeA;
    this.timeB = timeB;
    this.resultA = resultA;
    this.resultB = resultB;
    this.encerrado = encerrado;
    this.nome = nome;
    edited = false;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': idJogo,
      'resultA': resultA,
      'resultB': resultB,
      'encerrado': encerrado,
    };
  }

  static Future<List<Jogo>> pegarJogosUser(BuildContext context) async {
    try{
      List<int> idEquipes = List.generate(userJuergs.minhasEquipes.length, (index){
        return userJuergs.minhasEquipes[index].id;
        });
      
      var resposta = jsonDecode((await http.put(baseUrl + 'modalidades/pegarJogos/porEquipes', 
      body: {
        'id_equipes': json.encode(idEquipes),
      })).body);

      if(resposta['status'] == 'sucesso'){
        List<Jogo> jogos = <Jogo>[];
        for(int i = 0; i < resposta['data'].length; i++){
          jogos.add(Jogo.fromJson(resposta['data'][i]));
        }
        return jogos;
      }else{
        errorDialog(context, 'Erro!', 'Erro ao pegar os Jogos do usuário');
        return [];
      }

    }catch(e){
      print('Erro: ' + e.toString());
      errorDialog(context, 'Erro!', 'Erro ao pegar os Jogos do usuário');
      return [];
    }
  }

  static Future<List<Jogo>> pegarJogosPorEquipe(BuildContext context, int idEquipe) async {
    try {
      var resposta = jsonDecode((await http.put(
        baseUrl + 'modalidades/pegarJogos/porTime',
        body: {
          'id_equipe': idEquipe.toString()
        }
      )).body);

      if(resposta['status'] == 'sucesso'){
        List<Jogo> jogos = <Jogo>[];
        for(int i = 0; i < resposta['data'].length; i++){
          jogos.add(Jogo.fromJson(resposta['data'][i]));
        }
        return jogos;
        
      }else{
        print('Um erro aconteceu ao pegar os jogos');
        errorDialog(context, 'Erro', 'Aconteceu um problema ao pegar os jogos.');
        return [];
      }
    } catch (e) {
      print('Um erro ocorreu ao pegar jogos');
      print(e.toString());
      errorDialog(context, 'Erro', 'Aconteceu um problema ao pegar os jogos.');
      return [];
    }
  }

  static Future<List<Jogo>> pegaJogoPorFase(BuildContext context, Modalidade modalidade, int fase) async {
    try{
      var resposta = jsonDecode((await http.put(baseUrl + 'modalidades/listaTabela', 
      body: {
        'idModalidade': modalidade.id.toString(),
        'etapa':fase.toString(),
      })).body);
      
      if(resposta['status'] != null){
        if(resposta['status'] == 'sucesso'){
          List<Jogo> jogos = [];
          for(int i = 0; i < resposta['count']; i++){
            jogos.add(Jogo.fromJson(resposta['data'][i]));
          }
          return jogos;
        }
      }

      errorDialog(context, 'Erro!', 'Ocorreu um erro ao pegar os jogos');
      return [];
    }catch(e){
      errorDialog(context, 'Erro!', 'Ocorreu um erro ao pegar os jogos');
      return []; 
    }
  }

  static Future<List<Jogo>> pegarJogosPorModalidade(int idModalidade) async {
    try{
      http.Response res = await http.get(baseUrl + 'modalidades/pegarJogos/porModalidade/$idModalidade');
      var json = jsonDecode(res.body);
      if(json['status'] == 'sucesso'){
        List<Jogo> jogos = [];
        for(var element in json['data']){
          jogos.add(Jogo.fromJson(element));
        }
        return jogos;
      }else{

      return [];
      }
    }catch(e){
      print('Erro ao pegar jogos por modalidade');
      return [];
    }
  }

  Future<bool> atualizaLocalJogo(BuildContext context, String nomeLocal) async {
    try{
      http.Response res = await http.put(baseUrl + 'modalidades/atualizaLocalJogo/$idJogo/$nomeLocal');
      var json = jsonDecode(res.body);
      if(json['status'] == 'sucesso'){
        return true;
      }else{
        return false;
      }
    }catch(e){
      return false;
    }
  }

  static Future<void> atualizaJogos(List<Jogo> jogos, BuildContext context) async {
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
}
