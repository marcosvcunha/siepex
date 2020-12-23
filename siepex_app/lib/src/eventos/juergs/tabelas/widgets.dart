import 'package:flutter/material.dart';
import 'package:siepex/src/eventos/juergs/models/jogo.dart';

Widget jogoCard(Jogo jogo) {
    String timeA = jogo.timeA;
    String timeB = jogo.timeB;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 12, bottom: 16),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                spreadRadius: 2,
                color: Colors.grey[700],
                offset: Offset(0, 2),
              )
            ]),
        height: 60,
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
                          color: Color.fromRGBO(0x67, 0x44, 0xc7, 0.70)),
                      height: 35,
                      width: 35,
                      child: Center(
                          child: Text(
                        jogo.resultA.toString(),
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      )),
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
                          color: Color.fromRGBO(0x67, 0x44, 0xc7, 0.70)),
                      height: 35,
                      width: 35,
                      child: Center(
                          child: Text(
                        jogo.resultB.toString(),
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      )),
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
            Text('Ginasio Local, 23/09 17:30', style: TextStyle(fontSize: 14, color: Colors.grey[800]),),
          ],
        ),
      ),
    );
  }