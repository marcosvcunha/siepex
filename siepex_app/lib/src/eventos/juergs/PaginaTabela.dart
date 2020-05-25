import 'package:flutter/material.dart';

class PaginaTabela extends StatefulWidget {
  @override
  _PaginaTabelaState createState() => _PaginaTabelaState();
}

class _PaginaTabelaState extends State<PaginaTabela> {

  TableRow tableRow(){
    return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 4, left: 6),
                      child: Text('Time A1', style: TextStyle(color: Colors.black, fontSize: 18),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 4,),
                      child: Text('3', style: TextStyle(color: Colors.black, fontSize: 18), textAlign: TextAlign.center,),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 4,),
                      child: Text('0', style: TextStyle(color: Colors.black, fontSize: 18), textAlign: TextAlign.center,),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 4,),
                      child: Text('0', style: TextStyle(color: Colors.black, fontSize: 18), textAlign: TextAlign.center,),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 4,),
                      child: Text('4', style: TextStyle(color: Colors.black, fontSize: 18), textAlign: TextAlign.center,),
                    ),
                  ]
                );
  }

  Widget tabela() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                blurRadius: 3,
                spreadRadius: 1,
                color: Colors.grey[500],
                offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 12),
              child: Text('Grupo A',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 22,
                      fontWeight: FontWeight.w500)),
            ),
            Table(
              columnWidths: {0:FixedColumnWidth(150), 1:FixedColumnWidth(40),
              2:FixedColumnWidth(40), 3:FixedColumnWidth(40), 4:FixedColumnWidth(40)},
              border: TableBorder(
                //bottom: BorderSide(color: Colors.deepPurple, width: 2),
                //left:  BorderSide(color: Colors.deepPurple, width: 2),
                //right:  BorderSide(color: Colors.deepPurple, width: 2),
                //top:  BorderSide(color: Colors.deepPurple, width: 2),
                horizontalInside:  BorderSide(color: Colors.deepPurple, width: 2),
                verticalInside:  BorderSide(color: Colors.deepPurple, width: 2),
              ),
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 4, left: 6),
                      child: Text('Time', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 4,),
                      child: Text('J', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700), textAlign: TextAlign.center,),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 4,),
                      child: Text('V', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700), textAlign: TextAlign.center,),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 4,),
                      child: Text('D', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700), textAlign: TextAlign.center,),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 4,),
                      child: Text('P', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700), textAlign: TextAlign.center,),
                    ),
                  ]
                ),
                tableRow(),
                tableRow(),
                tableRow(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget selectionBar() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  spreadRadius: 2,
                  color: Colors.black54,
                  offset: Offset(0, 2),
                ),
              ]),
          height: 50,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    size: 32,
                    color: Colors.green[600],
                  ),
                  onPressed: () {},
                ),
              ),
              Text(
                '1ª Fase',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: IconButton(
                  icon: Icon(
                    Icons.chevron_right,
                    size: 32,
                    color: Colors.green[600],
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(title: Text('Tabela Futsal Masculino')),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: 9,
            itemBuilder: (context, index) {
              if (index == 0) {
                return SizedBox(height: 70);
              }
              return tabela();
            },
          ),
          selectionBar(),
        ],
      ),
    );
  }
}
