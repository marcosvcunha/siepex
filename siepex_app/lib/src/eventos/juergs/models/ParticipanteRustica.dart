import 'dart:convert';

import 'package:flutter/cupertino.dart';


class ParticipanteRustica extends ChangeNotifier{
  int number;
  String nome;
  String cpf;
  String celular;
  String unidade;
  int posicao;
  bool temPos; // Indica se já foi entrada a posição do participante na rústica.
  int tempo; // Tempo em milisegundos

  get tempoString{
    int min = (tempo / (1000 * 60)).floor();
    int seg = (tempo / (1000)).floor() % 60;
    int mili = tempo % 1000;
    return '${min.toString().padLeft(2, '0')}:${seg.toString().padLeft(2, '0')}:${mili.toString().padRight(3, '0')}';
  } 

  get celularFormated {
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


  ParticipanteRustica(Map jsonData){
    this.number = jsonData['id'];
    this.nome = jsonData['nome'];
    this.celular = jsonData['celular'];
    this.cpf = jsonData['cpf'];
    this.unidade = jsonData['unidade'];
    this.posicao = jsonData['posicao'];
    this.temPos = jsonData['tem_pos'];
    this.tempo = jsonData['tempo'];
    
  }

  Map<String, dynamic> toJson(){
    return {
      'cpf': cpf,
      'temPos': temPos,
      'posicao': posicao,
      'tempo': tempo,
    };
  }

}