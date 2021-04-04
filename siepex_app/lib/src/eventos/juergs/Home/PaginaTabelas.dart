import 'package:flutter/material.dart';
import 'package:siepex/icons/sport_icons.dart';
import 'package:siepex/src/eventos/juergs/models/modalidade.dart';
import 'package:siepex/src/eventos/juergs/Widgets/ColumnBuilder.dart';
import 'package:siepex/src/eventos/juergs/models/handledata.dart';
import 'package:siepex/src/eventos/juergs/tabelas/PaginaTabela.dart';
import 'package:siepex/src/eventos/juergs/tabelas/TabelaRustica.dart';
import 'package:provider/provider.dart';

class PaginaTabelas extends StatelessWidget {
  Widget competicaoButton(BuildContext context, IconData icone, String comp,
      String fase, Modalidade modalidade) {
    return Container(
      //color: Colors.blue,
      height: 65,
      child: ListTile(
        leading: Icon(icone, size: 35, color: Color(0xff372554)),
        title: Text(
          comp,
          style: TextStyle(
              fontSize: 22, color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          fase,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.black87),
        ),
        onTap: () {
          if (modalidade.nome != 'Rústica')
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider.value(
                    value: modalidade,
                    child: PaginaTabela(),
                  ),
                ));
          else
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TabelaRustica()));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    HandleData _handleData = HandleData();
    // TODO:: Implementar função para pegas as modalidades do DB
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 3,
        shadowColor: Colors.black,
        child: Container(
          //height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: FutureBuilder(
              future: Modalidade.getModalidades(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  List<Modalidade> modalidades = snapshot.data;
                  return ColumnBuilder(
                    itemCount: modalidades.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, top: 16, bottom: 12),
                          child: Text(
                            'Competições',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 26,
                                fontWeight: FontWeight.w600),
                          ),
                        );
                      } else {
                        return competicaoButton(
                            context,
                            modalidades[index - 1].icon,
                            modalidades[index - 1].nome,
                            modalidades[index - 1].faseStr +
                                ' - ' +
                                modalidades[index - 1].local,
                            modalidades[index - 1]);
                      }
                    },
                  );
                }
              }),

          // child: Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: <Widget>[
          // Padding(
          //   padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 12),
          //   child: Text('Competições', style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.w600),),
          // ),
          //     competicaoButton(context, Sport.soccer_ball, 'Futsal Masculino', '1ª Fase - Ginásio Local'),
          //     competicaoButton(context, Sport.soccer_ball,'Futsal Feminino', '2ª Fase - Ginásio Local'),
          //     competicaoButton(context, Sport.volleyball_ball, 'Voleybol', 'Final - Ginásio Local'),
          //     competicaoButton(context, Sport.shot_putter, 'Handbol Masculino', 'Semi-final - Ginásio Local'),
          //     competicaoButton(context, Sport.shot_putter, 'Handbol Feminino', 'Quartas de final - Ginásio Local'),
          //   ],
          // ),
        ),
      ),
    );
  }
}
