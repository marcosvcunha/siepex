import 'package:siepex/src/eventos/juergs/models/equipe.dart';

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
  List<Equipe> minhasEquipes = <Equipe>[];

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
      this.isOn = false});

  Estudante.fromJson(Map<String, dynamic> json) {
    this.nome = json['nome'].toString();
    this.cpf = json['cpf'].toString();
    this.email = json['email'].toString();
    this.instituicao = json['instituicao'].toString();
    this.indUergs = json['indUergs'].toString();
    this.campoUergs = json['campoUergs'].toString();
    this.indNecessidade = json['indNecessidade'].toString();
    this.tipoParticipante = json['tipoParticipante'].toString();
    this.celular = json['celular'].toString();
    this.isOn = true;
    //this.modalidadesJuiz = json['modalidadesJuiz'].toString();
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

}
