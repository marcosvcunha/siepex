import 'package:flutter/material.dart';
import 'package:siepex/src/eventos/juergs/models/handledata.dart';
import '../../../../models/modalidade.dart';
import 'package:provider/provider.dart';

import '../Widgets/modalidadeCard.dart';

class ModalidadesPage extends StatelessWidget {
  final HandleData _handleData = HandleData();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
          future: Modalidade.getModalidades(),
          builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Mostra Isso quando os dados estão sendo carregados.
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            // Se a função Future retornar alguma coisa, mostra aqui.
            if (snapshot.hasData) {
              List<Modalidade> modalidades = snapshot.data;
              return ListView.builder(
                  itemCount: modalidades.length,
                  itemBuilder: (context, index) {
                    return ChangeNotifierProvider.value(
                      value: modalidades[index],
                      child: ModalidadeCard());
                  });
            } else {
              // Se nenhuma modalidade for cadastrada.
              return Center(
                child: Text('Nenhuma Modalidade Cadastrada.'),
              );
            }
          }
        });
  }
}

