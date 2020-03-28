
class Estudante {
  String nome;
  String cpf;
  String email;
  String instituicao;
  String indUergs;
  String campoUergs;
  String tipoParticipante;
  String indNecessidade;

  Estudante(
      {this.nome,
      this.cpf,
      this.email,
      this.instituicao,
      this.indUergs,
      this.campoUergs,
      this.indNecessidade,
      this.tipoParticipante});

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['cpf'] = this.cpf;
    data['email'] = this.email;
    data['instituicao'] = this.instituicao;
    data['indUergs'] = this.indUergs;
    data['campoUergs'] = this.campoUergs;
    data['indNecessidade'] = this.indNecessidade;
    data['tipoParticipante'] = this.tipoParticipante;
    return data;
  }
}
