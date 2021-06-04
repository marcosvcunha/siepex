

import 'package:flutter/material.dart';

pushto(BuildContext context, Widget page) async {
  return await Navigator.push(context, MaterialPageRoute(
    builder: (context) => page,
  ));
}

