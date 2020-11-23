

class Jogo{
  String timeA;
  String timeB;
  int resultA;
  int resultB;
  bool encerrado;
  String nome; // Nome do jogo. Ex: Jogo 1, Jogo 2, ...
  bool edited; // Indica se o resultado foi alterado. (Utilizado no lançamento de resultados)
  bool beeingEdited = false; // Para saber se o resultado está sendo editado. (Utilizado no lançamento de resultados)

  get resultAStr{
    if(encerrado)
      return resultA.toString();
    else
      return '-';
  }

  get resultBStr{
    if(encerrado)
      return resultB.toString();
    else
      return '-';
  }

  Jogo.fromJson(jsonData){
    // TODO
  }

  Jogo(String timeA, String timeB, int resultA, int resultB, bool encerrado, String nome){
    this.timeA = timeA;
    this.timeB = timeB;
    this.resultA = resultA;
    this.resultB = resultB;
    this.encerrado = encerrado;
    this.nome = nome;
    edited = false;
  }

  static Future<List<Jogo>> getJogos() async {
    return [];
  }

}