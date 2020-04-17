class Equipe{
  String nome;
  int id;
  int idModalidade;
  String nomeModalidade;
  int maximoParticipantes;
  int numeroParticipantes;
  Equipe.fromJson(jsonData){
    this.nome = jsonData['nome_equipe'];
    this.id = jsonData['id'];
    this.idModalidade = jsonData['id_modalidade'];
    this.nomeModalidade = jsonData['nome_modalidade'];
    this.maximoParticipantes = jsonData['maximo_participantes'];
    this.numeroParticipantes = jsonData['numero_participantes'];
  }
}
