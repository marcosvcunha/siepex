  import 'package:flutter/material.dart';

Widget squarishButton(String text, Function onPressed){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.green,
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            spreadRadius: 1,
            color: Colors.grey,
            offset: Offset(0, 0),
          ),
        ],
      ),
      height: 50,
      width: double.infinity,
      child: FlatButton(
        onPressed: onPressed,
              child: Center(child: Text(text, 
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w500
          ),
          )),
      ),
    );
  }