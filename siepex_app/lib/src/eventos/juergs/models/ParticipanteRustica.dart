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
  int tempo;

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

}