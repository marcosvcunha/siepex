import 'dart:convert';

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:siepex/models/modalidade.dart';
import 'package:siepex/models/serializeJuergs.dart';
import 'package:siepex/src/eventos/juergs/Widgets/errorDialog.dart';
import 'package:siepex/src/eventos/juergs/models/equipe.dart';
import 'package:http/http.dart' as http;
import 'package:siepex/src/config.dart';

class HandleData {
  // Aqui vai pegar os dados do DB e retornar uma lista com as modalidades
  Future<List<Modalidade>> getModalidades() async {
    try {
      var resposta = jsonDecode((await http.put(
        baseUrl + 'modalidades/getAll',
      ))
          .body);
      List<Modalidade> listaModalidade = new List<Modalidade>();
      if (resposta['status'] != null) {
        if (resposta['status'] == 'ok') {
          for (var i = 0; i != resposta['count']; i++) {
            DateTime date = DateTime.parse(resposta['data'][i]['limit_date']);
            Modalidade modalidade = new Modalidade(
                resposta['data'][i]['id'],
                resposta['data'][i]['nome_modalidade'],
                int.tryParse(
                    resposta['data'][i]['maximo_participantes'].toString()),
                false, date, resposta['data'][i]['fase']);
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

  // Pega as equipes registradas para a modalidade.
  Future<List<Equipe>> getEquipes(int idModalidade) async {
    try {
      var resposta = jsonDecode((await http.put(baseUrl + 'obtemEquipes/',
              body: {'id_modalidade': idModalidade.toString()}))
          .body);
      if (resposta['count'] == 0)
        return [];
      else {
        List<Equipe> equipesList = new List<Equipe>();
        for (int i = 0; i < resposta['count']; i++) {
          equipesList.add(Equipe.fromJson(resposta['data'][i]));
          equipesList[i].index = i;
        }
        return equipesList;
      }
    } catch (e) {
      print('Erro ao pegar Equipes ' + e.toString());
      return [];
    }
  }

  Future<List<Equipe>> getMyEquipes(String userCpf) async {
    try {
      var resposta = jsonDecode((await http.put(baseUrl + 'obtemEquipes/',
              body: {'user_cpf': userCpf}))
          .body);
      if (resposta['count'] == 0)
        return [];
      else {
        List<Equipe> equipesList = [];
        for (int i = 0; i < resposta['count']; i++) {
          equipesList.add(Equipe.fromJson(resposta['data'][i]));
        }
        return equipesList;
      }
    } catch (e) {
      print(e);
      return [];
    }
  }


  Future criarEquipe(
      BuildContext context, Modalidade modalidade, String nomeEquipe, bool isActive) async {
    try {
      if(!isActive){
        errorDialog(context, 'Erro', 'Inscrições Encerradas');
        return;
      }
      if (nomeEquipe.isNotEmpty) {
        var resposta =
            jsonDecode((await http.put(baseUrl + 'equipe/cadastra', body: {
          'id_modalidade': modalidade.id.toString(),
          'nome_equipe': nomeEquipe,
          'nome_modalidade': modalidade.nome,
          'maximo_participantes': modalidade.maxParticipantes.toString(),
          'user_name': userJuergs.nome,
          'user_cpf' : userJuergs.cpf,
          'user_cel': userJuergs.celular,
        })).body);
        if (resposta['status'] == 'sucesso') {
          userJuergs.minhasEquipes.add(Equipe.fromJson(resposta['data']));
          errorDialog(context, 'Sucesso', 'Equipe Criada');
          return;
        } else if(resposta['erro'] == 'Equipe já existe'){       
            errorDialog(context, 'Erro ao criar equipe!',
                'Já existe uma equipe com este nome.');
            return;          
        }
        else if(resposta['erro'] == 'ja_cadastrado_na_modalidade'){
          errorDialog(context, 'Erro ao criar equipe!',
                'Você ja esta cadastrado nesta modalidade.');
            return;   
        }
      } else {
        errorDialog(context, 'Erro ao criar equipe!',
            'O nome da equipe é obrigatório.');
      }
    } catch (e) {
      print('Erro ao criar Equipe: ' + e.toString());
      return;
    }
  }
  
}
