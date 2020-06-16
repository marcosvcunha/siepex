import 'package:flutter/material.dart';

Widget roundButton(String text, dynamic color, IconData icon, Function func) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Container(
          height: 46,
          //width: 95,
          width: 130,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(28),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: FlatButton(
              onPressed: func != null ? func : null,
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      icon,
                      size: 26,
                      color: Colors.white,
                    ),
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