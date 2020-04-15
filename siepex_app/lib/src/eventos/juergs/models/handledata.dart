import 'package:flutter/material.dart';
import 'dart:async';
import 'package:siepex/models/modalidade.dart';
import 'package:siepex/src/eventos/juergs/models/equipe.dart';

class HandleData {

  // Aqui vai pegar os dados do DB e retornar uma lista com as modalidades
  Future<List<Modalidade>> getModalidades() async {
    await Future.delayed(Duration(seconds: 2)); // Delay
    List<Modalidade> modalidades = [
      Modalidade(0, 'Ciclismo', 5, true),
      Modalidade(1, 'Natação', 10, false),
      Modalidade(2, 'Futebol', 22, true),
      Modalidade(3, 'Ping Pong', 6, false),
    ];
    return modalidades;
  }

  // Pega as equipes registradas para a modalidade.
  Future<List<Equipe>> getEquipes(int idModalidade){
    return null;
  }
}
