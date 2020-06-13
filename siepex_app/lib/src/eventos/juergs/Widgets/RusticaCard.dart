import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siepex/models/modalidade.dart';
import 'package:siepex/models/serializeJuergs.dart';
import 'package:siepex/src/eventos/juergs/PaginaEquipe.dart';
import 'package:siepex/src/eventos/juergs/Widgets/participantesdialog.dart';
import 'package:siepex/src/eventos/juergs/models/equipe.dart';
import 'package:siepex/src/eventos/juergs/models/handledata.dart';

class RusticaCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Equipe equipe = Provider.of<Equipe>(context);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              gradient: LinearGradient(
                  colors: [Color(0xFF3498B7), Color(0xFF7db0a2)])),
          height: 50,
          child: Column(
            children: <Widget>[
              ListTile(
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    equipe.nome,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}