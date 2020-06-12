import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:siepex/icons/sport_icons.dart' as sportIcon;
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';

class PaginaEquipe extends StatefulWidget {
  @override
  _PaginaEquipeState createState() => _PaginaEquipeState();
}

class _PaginaEquipeState extends State<PaginaEquipe> {
  TextStyle txtStyle1(bool bold) {
    return TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: bold ? FontWeight.w600 : FontWeight.w400);
  }

  Widget roundButton(String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Container(
          height: 46,
          //width: 95,
          width: 130,
          decoration: BoxDecoration(
            color: Colors.green[700],
            borderRadius: BorderRadius.circular(28),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: FlatButton(
              onPressed: () {},
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.swap_horiz, size: 26, color: Colors.white,),
                    Expanded(
                      child: Text(
                          text,
                          maxLines: 2,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                    ),
                  ],
                ),
              )),
            ),
          ),
        ),
      ),
    );
  }

  var _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página da Equipe'),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('Equipe Legal',
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        )),
                    SizedBox(
                      width: 8,
                    ),
                    IconButton(
                      onPressed: (){},
                                          icon: Icon(
                        Icons.edit,
                        size: 28,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 26.0,
                    top: 8,
                  ),
                  child: Icon(sportIcon.Sport.volleyball_ball,
                      color: Colors.deepPurple, size: 55),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, top: 16, bottom: 8),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Capitão: ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Marcos Vinicius Cunha',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Contato: ', style: txtStyle1(true)),
                    Text(
                      '99387-5092',
                      style: txtStyle1(false),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Modalidade: ', style: txtStyle1(true)),
                    Text(
                      'Futsal Masculino',
                      style: txtStyle1(false),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Participantes: ', style: txtStyle1(true)),
                    Text(
                      '8/12',
                      style: txtStyle1(false),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
          roundButton('Alterar Capitão'),
          Divider(
            height: 30,
            color: Colors.black87,
            thickness: 1,
            indent: 60,
            endIndent: 60,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text(
              'Participantes',
              style: TextStyle(
                color: Colors.blue[800],
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40.0, top: 12),
            child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight: 200,
                ),
                child: FadingEdgeScrollView.fromScrollView(
                  child: ListView.builder(
                    controller: _controller,
                    itemCount: 12,
                    itemBuilder: (context, index) => Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Container(
                            height: 7,
                            width: 7,
                            decoration: new BoxDecoration(
                              color: Colors.deepPurple[700],
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Text(
                          faker.person.name(),
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          overflow: TextOverflow.fade,
                        ),
                      ],
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
