import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:siepex/src/config.dart';
import 'package:siepex/models/serializeJuergs.dart';
import 'package:siepex/src/eventos/juergs/Widgets/errorDialog.dart';

class Equipe extends ChangeNotifier{
  String nome;
  int id;
  int idModalidade;
  String nomeModalidade;
  int maximoParticipantes;
  int numeroParticipantes;
  String cpfCapitao;
  String celCapitao;
  List<String> participantesCpf = <String>[];
  List<String> participantesNomes = <String>[];
  bool isLoading = false;

  get nomeCapitao => participantesNomes[indexCapitao()];
  // Retorna a string do cel com o traço no meio.
  get celCapitaoFormated => celCapitao.substring(0, 5) + '-' + celCapitao.substring(5);
  // Retorna a string com numero de participantes / maximo de participantes
  get partFormat => numeroParticipantes.toString() + '/' + maximoParticipantes.toString();


  Equipe.fromJson(jsonData) {
    this.nome = jsonData['nome_equipe'];
    this.id = jsonData['id'];
    this.idModalidade = jsonData['id_modalidade'];
    this.nomeModalidade = jsonData['nome_modalidade'];
    this.maximoParticipantes = int.parse(jsonData['maximo_participantes']
        .toString()); // Nao entendo porque, mas as vezes a api
    this.numeroParticipantes = int.parse(jsonData['numero_participantes']
        .toString()); // retorna int, outras retorna string. ??
    this.cpfCapitao = jsonData['cpf_capitao'];
    this.celCapitao = jsonData['celular_capitao'];
    try {
      
      for (int i = 0; i < jsonData['participantes_cadastrados'].length; i++) {
        participantesCpf.add(jsonData['participantes_cadastrados'][i]);
        participantesNomes.add(jsonData['nomes_participantes'][i]);
      }
    } catch (e) {
      print('Erro ao Criar Equipe');
    }
  }

  int indexCapitao(){
    for(int i = 0; i < this.participantesCpf.length; i++){
      if(this.cpfCapitao == this.participantesCpf[i]){
        return i;
      }
    }
    return -1;
  }

  Future entrarEquipe(BuildContext context, bool isActive) async {
    try{
      if(!isActive){
        errorDialog(context, 'Erro', 'Inscrições Encerradas.');
        return;
      }else if(numeroParticipantes == maximoParticipantes){
        errorDialog(context, 'Erro', 'A equipe está cheia.');
      }
      isLoading = true;
      notifyListeners();
      var resposta =
            jsonDecode((await http.put(baseUrl + 'equipe/entra', body: {
          'user_cpf': userJuergs.cpf,
          'equipe_id': id.toString()
        })).body);
        Equipe updatedTeam = Equipe.fromJson(resposta['data']);
        participantesNomes = updatedTeam.participantesNomes;
        participantesCpf = updatedTeam.participantesCpf;
        numeroParticipantes = updatedTeam.numeroParticipantes;
        userJuergs.minhasEquipes.add(updatedTeam);
        isLoading = false;
        notifyListeners();
        return;
    }catch(e){
      print("Erro ao entrar na equipe: " + e.toString());
      return;
    }
  }

  Future updateName(BuildContext context, String newName) async {
    try{
      if(newName != nome){
        var resposta = jsonDecode((await http.put(baseUrl + 'equipe/changeName', body: {
          'id_modalidade': idModalidade.toString(),
          'nome_modalidade': nomeModalidade,
          'nome_equipe': newName,
          'id_equipe': id.toString(),
        })).body);
        if(resposta['status'] == 'erro'){
          print(resposta['erro']);
          errorDialog(context, 'Erro', 'Nome da Equipe já existe.');
        }else{
          nome = newName;
          userJuergs.updateTeamName(id, nome);
          notifyListeners();
          // print('Mudou o Nome');
        }
      }else{
        // print('Não Mudou o nome');
      }
    }catch(e){
      print('Erro ao mudar nome da Equipe: ' + e.toString());
    }
  }
}
