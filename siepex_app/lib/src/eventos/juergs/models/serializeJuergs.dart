import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:siepex/src/config.dart';
import 'package:siepex/src/eventos/juergs/Widgets/errorDialog.dart';
import 'package:siepex/src/eventos/juergs/models/equipe.dart';
import 'package:http/http.dart' as http;


// TODO:: Transformar instanciar userJuergs na raiz do app, passar para as páginas por provider e transformar 
// em changenotifier (se possivel).

//TODO: fazer a persistencia do user. (continuar logado após fechar o app)

Estudante userJuergs = new Estudante();

class Estudante {
  String nome;
  String cpf;
  String email;
  String instituicao;
  String indUergs;
  String campoUergs;
  String tipoParticipante;
  String indNecessidade;
  String celular;
  String modalidadesJuiz;
  bool isOn;
  /*
    Minhas equipes contem as equipes do usuario atual.
    É utilizada na página Modalidade, para saber quais as modalidades que o usuario já está inscrito.
    A lista é preenchida quando o usuario faz login, e é atualizada (pelo app) quando o usuario cria
    ou entra em uma equipe.
   */
  List minhasEquipes = [];

  List<String> get listaModalidades {
    List<String> mods = modalidadesJuiz.replaceAll(',', '').split(' ');
    // if(mods.length > 2);
    return mods;
  }
  
  
  Estudante(
      {this.nome,
      this.cpf,
      this.email,
      this.instituicao,
      this.indUergs,
      this.campoUergs,
      this.indNecessidade,
      this.tipoParticipante,
      this.celular,
      this.modalidadesJuiz,
      this.isOn = false,
      });

  Estudante.fromJson(Map<String, dynamic> json) {
    this.nome = json['nome'].toString();
    this.cpf = json['cpf'].toString();
    this.email = json['email'].toString();
    this.instituicao = json['instituicao'].toString();
    this.indUergs = json['ind_uergs'].toString();
    this.campoUergs = json['campos_uergs'].toString();
    this.indNecessidade = json['ind_necessidades_especiais'].toString();
    this.tipoParticipante = json['tipo_participante'].toString();
    this.celular = json['celular'].toString();
    this.modalidadesJuiz = json['modalidades_juiz'].toString();
    this.isOn = true;
  }

  Map<String, dynamic> toJson() =>
  {
    'name': this.nome,
    'cpf': this.cpf,
    'email': this.email,
    'instituicao': this.instituicao,
    'indUergs': this.indUergs,
    'campoUergs': this.indUergs,
    'indNecessidade': this.indNecessidade,
    'tipoParticipante': this.tipoParticipante,
    'celular': this.celular,
    'modalidadesJuiz' : this.modalidadesJuiz,
  };

  void logout(){
    this.nome = null;
    this.cpf = null;
    this.email = null;
    this.instituicao = null;
    this.indUergs = null;
    this.campoUergs = null;
    this.tipoParticipante = null;
    this.indNecessidade = null;
    this.isOn = false;
    this.celular = null;
    this.modalidadesJuiz = null;
  }


  get celularString{
      if (celular.isNotEmpty && celular != '0') {
      if (celular.length == 11) {
        return "(" + celular.substring(0,2) + ")" + celular.substring(2,7) + "-" + celular.substring(7,11);
      } else {
        return celular;
      }
    } else {
      return 'Não Cadastrou';
    }
  }

  // Recebe o id de uma equipe e o novo nome e atualiza na lista das minhas equipes.
  void updateTeamName(int id, String newName){
    for(Equipe eq in minhasEquipes){
      if(eq.id == id){
        eq.nome = newName;
        return;
      }
    }
  }

  // Determina se o usuario já possui equipe para dada modalidade.
  bool temEquipe(String modalidade){
    // Determina se o usuario já possui equipe para dada modalidade.    
    for(Equipe equipe in minhasEquipes){
      if(equipe.nomeModalidade == modalidade)
        return true;
    }
    return false;
  }

  // Determina se o usuario já possui equipe para dada modalidade.
  bool temEquipeId(int id){
    for(Equipe equipe in minhasEquipes){
      if(equipe.idModalidade == id)
        return true;
    }
    return false;
  }

  // Determina se este usuário é membro da equipe.
  bool isInTeam(int id){
    for(Equipe eq in minhasEquipes){
      if(eq.id == id){
        return true;
      }
    }
    return false;
  }

  static Future<List<Estudante>> pegarJuizes() async {
    try{
      http.Response res = await http.get(baseUrl + 'obtemParticipante/juizes');
      var json = jsonDecode(res.body);
      if(json['status'] == 'sucesso'){
        List<Estudante> juizes = [];
        for(var juiz in json['data']){
          juizes.add(Estudante.fromJson(juiz));
        }
        return juizes;
      }else{
        print('Erro ao pegar os juizes.');
        return [];
      }
    }catch(e){
      print('Erro ao pegar os juizes: ' + e.toString());
      return [];
    }
  }
 
  
}
