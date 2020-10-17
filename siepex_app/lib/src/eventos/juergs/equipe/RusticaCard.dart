import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siepex/src/eventos/juergs/models/ParticipanteRustica.dart';
// import 'package:siepex/models/modalidade.dart';
// import 'package:siepex/models/serializeJuergs.dart';
// import 'package:siepex/src/eventos/juergs/equipe/PaginaEquipe.dart';
// import 'package:siepex/src/eventos/juergs/Widgets/participantesdialog.dart';
import 'package:siepex/src/eventos/juergs/models/equipe.dart';
// import 'package:siepex/src/eventos/juergs/models/handledata.dart';

class RusticaCard extends StatelessWidget {
  final ParticipanteRustica participante;

  RusticaCard({this.participante});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            gradient:
                LinearGradient(colors: [Color(0xFF3498B7), Color(0xFF7db0a2)])),
        // height: 50,
        child: ListTile(
          leading: Text(
            participante.number.toString(),
            style: TextStyle(
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.w500),
          ),
          title: Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8),
            child: Text(
              participante.nome,
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8),
            child: Text(participante.unidade),
          ),
        ),
      ),
    );
  }
}
