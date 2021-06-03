

import 'package:flutter/material.dart';

void pushto(BuildContext context, Widget page){
  Navigator.push(context, MaterialPageRoute(
    builder: (context) => page,
  ));
}