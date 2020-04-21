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
    this.maximoParticipantes = int.parse(jsonData['maximo_participantes'].toString()); // Nao entendo por que, mas as vezes a api
    this.numeroParticipantes = int.parse(jsonData['numero_participantes'].toString()); // retorna int, outras retorna string. ??
  }
}
