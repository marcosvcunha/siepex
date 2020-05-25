class Equipe{
  String nome;
  int id;
  int idModalidade;
  String nomeModalidade;
  int maximoParticipantes;
  int numeroParticipantes;
  List<String> participantesCpf = <String>[];
  List<String> participantesNomes = <String>[];

  Equipe.fromJson(jsonData){
    this.nome = jsonData['nome_equipe'];
    this.id = jsonData['id'];
    this.idModalidade = jsonData['id_modalidade'];
    this.nomeModalidade = jsonData['nome_modalidade'];
    this.maximoParticipantes = int.parse(jsonData['maximo_participantes'].toString()); // Nao entendo porque, mas as vezes a api
    this.numeroParticipantes = int.parse(jsonData['numero_participantes'].toString()); // retorna int, outras retorna string. ??
    try{
      print(jsonData['participantes_cadastrados'].length);
      print(jsonData['nomes_participantes'].length);
    for(int i = 0; i < jsonData['participantes_cadastrados'].length; i ++){
      participantesCpf.add(jsonData['participantes_cadastrados'][i]);
      participantesNomes.add(jsonData['nomes_participantes'][i]);
    }  
    }catch(e){
      print('Erro ao Criar Equipe');
    }
  }
}
