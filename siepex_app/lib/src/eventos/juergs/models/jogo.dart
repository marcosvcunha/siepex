

import 'dart:convert';

class Jogo{
  String timeA;
  String timeB;
  int idJogo;
  int resultA;
  int resultB;
  bool encerrado;
  String nome; // Nome do jogo. Ex: Jogo 1, Jogo 2, ...
  bool edited; // Indica se o resultado foi alterado. (Utilizado no lançamento de resultados)
  bool beeingEdited = false; // Para saber se o resultado está sendo editado. (Utilizado no lançamento de resultados)

  int idTimeA;
  int idTimeB;
  int classModalidade;
  String etapaJogo;

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

  Jogo.fromJson(Map<String, dynamic> json){
    this.timeA = json['time_a'];
    this.timeB = json['time_b'];
    this.idTimeA = json['id_time_a'];
    this.idTimeB = json['id_time_b'];
    this.resultA = json['resultado_a'];
    this.resultB = json['resultado_b'];
    this.encerrado = json['encerrado'];
    this.classModalidade = json['modalidade'];
    this.etapaJogo = json['etapa_jogo'];
    this.nome = 'Jogo';
    this.idJogo = json['id'];
    this.edited = false;
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

  Map<String, dynamic> toJson(){
    return {
      'id': idJogo,
      'resultA':resultA,
      'resultB':resultB,
      'encerrado': encerrado,
    };
  }

}

// class JogosJuers {
//   String timeA;
//   String timeB;
//   int idTimeA;
//   int idTimeB;
//   int resultadoA;
//   int resultadoB;
//   bool encerrado;
//   int classModalidade;
//   String etapaJogo;

//   JogosJuers.retornaLinhaJuergs(Map<String, dynamic> json) {
//     this.timeA = json['time_a'];
//     this.timeB = json['time_b'];
//     this.idTimeA = json['id_time_a'];
//     this.idTimeB = json['id_time_b'];
//     this.resultadoA = json['resultado_a'];
//     this.resultadoB = json['resultado_b'];
//     this.encerrado = json['encerrado'];
//     this.classModalidade = json['modalidade'];
//     this.etapaJogo = json['etapa_jogo'];
//   }


// }