import 'package:flutter/material.dart';
// import 'package:siepex/icons/sport_icons.dart';
import 'package:siepex/src/eventos/juergs/models/modalidade.dart';
import 'package:provider/provider.dart';
import 'package:siepex/src/eventos/juergs/admin/CompPage.dart';

import '../models/handledata.dart';

/* 
  Pagina para gerenciar as competições.
  Mostra as competições a a fase atual da competição.
  Clicando na competição, vai pra página para gerenciar a competição escolhida.
*/
class ManageCompPage extends StatelessWidget {
  HandleData _handleData = HandleData();

  Widget _modalidadeCard(BuildContext context, Modalidade modalidade) {
    return ListTile(
      leading: Icon(
        modalidade.icon,
        color: Colors.black87,
        size: 35,
      ),
      title: Text(
        modalidade.nome,
        style: TextStyle(color: Colors.black, fontSize: 22),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
      trailing: Text(
        modalidade.faseStr,
        style: TextStyle(color: Colors.black, fontSize: 16),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider.value(
                      value: modalidade,
                      child: CompetitionPage(),
                    )));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Competições'),
      ),
      body: FutureBuilder(
        future: Modalidade.getModalidades(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return _modalidadeCard(context, snapshot.data[index]);
              },
            );
          }
        },
      ),
    );
  }
}
