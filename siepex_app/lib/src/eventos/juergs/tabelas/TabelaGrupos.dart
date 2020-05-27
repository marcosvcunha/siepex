import 'package:flutter/material.dart';

class TabelaGrupos extends StatefulWidget {
  @override
  _TabelaGruposState createState() => _TabelaGruposState();
}

class _TabelaGruposState extends State<TabelaGrupos> {
  List<bool> showTable = List.generate(8, (index) {
    return true;
  });
  // Apenas para demonstração
  List<String> _groups = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];

  TableRow tableRow(String time) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.only(top: 4.0, bottom: 4, left: 6),
        child: Text(
          time,
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
          top: 4.0,
          bottom: 4,
        ),
        child: Text(
          '3',
          style: TextStyle(color: Colors.black, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
          top: 4.0,
          bottom: 4,
        ),
        child: Text(
          '0',
          style: TextStyle(color: Colors.black, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
          top: 4.0,
          bottom: 4,
        ),
        child: Text(
          '0',
          style: TextStyle(color: Colors.black, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
          top: 4.0,
          bottom: 4,
        ),
        child: Text(
          '4',
          style: TextStyle(color: Colors.black, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    ]);
  }

  Widget tabela(int index) {
    String group = _groups[index].toString();
    return Padding(
      key: ValueKey(1),
      padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Container(
        height: 230,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 14.0, bottom: 12),
              child: Text('Grupo ' + _groups[index].toString(),
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 22,
                      fontWeight: FontWeight.w500)),
            ),
            Table(
              columnWidths: {
                0: FixedColumnWidth(150),
                1: FixedColumnWidth(40),
                2: FixedColumnWidth(40),
                3: FixedColumnWidth(40),
                4: FixedColumnWidth(40)
              },
              border: TableBorder(
                //bottom: BorderSide(color: Colors.deepPurple, width: 2),
                //left:  BorderSide(color: Colors.deepPurple, width: 2),
                //right:  BorderSide(color: Colors.deepPurple, width: 2),
                //top:  BorderSide(color: Colors.deepPurple, width: 2),
                horizontalInside:
                    BorderSide(color: Colors.deepPurple, width: 2),
                verticalInside: BorderSide(color: Colors.deepPurple, width: 2),
              ),
              children: [
                TableRow(children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 4.0, bottom: 4, left: 6),
                    child: Text(
                      'Time',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4.0,
                      bottom: 4,
                    ),
                    child: Text(
                      'J',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4.0,
                      bottom: 4,
                    ),
                    child: Text(
                      'V',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4.0,
                      bottom: 4,
                    ),
                    child: Text(
                      'D',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4.0,
                      bottom: 4,
                    ),
                    child: Text(
                      'P',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),
                tableRow('Time ${group}1'),
                tableRow('Time ${group}2'),
                tableRow('Time ${group}3'),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 7.0, right: 8),
                child: Container(
                    //color: Colors.green,
                    height: 45,
                    width: 120,
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          showTable[index] = false;
                        });
                      },
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.swap_horiz,
                            size: 32,
                            color: Colors.red,
                          ),
                          Text(
                            'Jogos',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _jogoTile(String timeA, String timeB) {
    return Container(
      decoration: BoxDecoration(
        //color: Colors.blue,
        border: Border(
            //bottom: BorderSide(color: Colors.deepPurple, width: 2)
            ),
      ),
      height: 42,
      //width: 240,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      timeA,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                          overflow: TextOverflow.ellipsis,
                    ),
                  )),
              Expanded(
                flex: 1,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      //color: Colors.grey[400],
                      //6744C7
                      color: Color.fromRGBO(0x67, 0x44, 0xc7, 0.70)
                    ),
                    height: 35,
                    width: 35,
                    child: Center(child: Text('0', style: TextStyle(fontSize: 18, color: Colors.black),)),
                  ),
                ),
              ),
              // SizedBox(width: 30),
              Expanded(
                flex: 1,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color.fromRGBO(0x67, 0x44, 0xc7, 0.70)
                    ),
                    height: 35,
                    width: 35,
                    child: Center(child: Text('0', style: TextStyle(fontSize: 18, color: Colors.black),)),
                  ),
                ),
              ),
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(
                      timeB,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )),
            ],
          ),
          //Text('Ginasio Local, 23/09 17:30', style: TextStyle(fontSize: 14, color: Colors.grey[700]),)
        ],
      ),
    );
  }

  Widget jogosCard(int index) {
    String group = _groups[index].toString();
    return Padding(
      key: ValueKey(2),
      padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Container(
        height: 230,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 14.0, bottom: 12),
              child: Text('Grupo ' + _groups[index].toString(),
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 22,
                      fontWeight: FontWeight.w500)),
            ),
            _jogoTile('Time ${group}1', 'Time ${group}2 '),
            _jogoTile('Time ${group}1', 'Time ${group}3 '),
            _jogoTile('Time ${group}2', 'Time ${group}3 '),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 7.0, right: 8),
                child: Container(
                    //color: Colors.green,
                    height: 45,
                    width: 120,
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          showTable[index] = true;
                        });
                      },
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.swap_horiz,
                            size: 32,
                            color: Colors.red,
                          ),
                          Text(
                            'Tabela',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
            itemCount: 9,
            itemBuilder: (context, index) {
              if (index == 0) {
                return SizedBox(height: 70);
              }
              return AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                child: showTable[index - 1]
                    ? tabela(index - 1)
                    : jogosCard(index - 1),
              );
              // return showTable[index - 1] ? tabela(index - 1) : jogosCard(index - 1);
            },
          );
  }
}