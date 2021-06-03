

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function onTap;

  CustomButton({this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.green
        ),
        child: Center(
          child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),),
        ),
        )
      ),
    );
  }
}