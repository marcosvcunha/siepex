import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siepex/models/modalidade.dart';
import 'package:siepex/models/serializeJuergs.dart';
import 'package:siepex/src/eventos/juergs/equipe/PaginaEquipes.dart';

class ModalidadeCard extends StatefulWidget {
  @override
  _ModalidadeCardState createState() => _ModalidadeCardState();
}

class _ModalidadeCardState extends State<ModalidadeCard> {
  @override
  Widget build(BuildContext context) {
    Modalidade modalidade = Provider.of<Modalidade>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromRGBO(0, 60, 125, 1),
              //color: Color(0xff56FBFB),
              width: 2,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Color(0xff86A5D9),
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                color: Colors.black54,
                offset: Offset(2, 2),
                spreadRadius: 1,
              ),
            ]),
        //height: 125,
        // constraints: BoxConstraints(
        //   // minHeight: 125,
        //   maxHeight: 125,
        // ),
        //width: 300,
        child: FlatButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide(
                      width: 4,
                      //color: Color.fromRGBO(0, 60, 125, 1),
                      color: Color(0xff5F4BB6),
                    )),
                  ),
                  height: 100,
                  width: 100,
                  //color:Colors.white,
                  child: modalidade.icon,
                ),
              ),
              SizedBox(width: 15),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        modalidade.nome,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Tamanho max. da equipe: " +
                              modalidade.maxParticipantes.toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Fim das inscrições: " + modalidade.dataLimiteString,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text("Inscrito:"),
                          Checkbox(
                            activeColor: Colors.green,
                            value: userJuergs.temEquipe(modalidade.nome),
                            checkColor: Colors.white,
                            onChanged: (value) {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          onPressed: () async {
            var f = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PaginaEquipes(modalidade: modalidade)));
            setState(() {});
          },
        ),
      ),
    );
  }
}
