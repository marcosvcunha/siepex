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
  bool isOn;

  Estudante(
      {this.nome,
      this.cpf,
      this.email,
      this.instituicao,
      this.indUergs,
      this.campoUergs,
      this.indNecessidade,
      this.tipoParticipante,
      this.isOn = false});

  fromJson(Map<String, dynamic> json) {
    this.nome = json['nome'].toString();
    this.cpf = json['cpf'].toString();
    this.email = json['email'].toString();
    this.instituicao = json['instituicao'].toString();
    this.indUergs = json['indUergs'].toString();
    this.campoUergs = json['campoUergs'].toString();
    this.indNecessidade = json['indNecessidade'].toString();
    this.tipoParticipante = json['tipoParticipante'].toString();
    return this;
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
  }
}
