import 'package:flutter/material.dart';
// import 'package:ja_pensou/theme/colors.dart';
// import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import '../config.dart';

class Loading {
  static Future<void> neverSatisfied(BuildContext context, bool load) async {
    if (load) {
      return showDialog(
        context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async {return false;},
        child: Center(
          child: SpinKitChasingDots(
            duration: Duration(seconds: 1),
          color: Theme.of(context).primaryColor
          // size: dotsSize,
        ),
        ),
      ), barrierDismissible: false);
    } else {
      Navigator.pop(context);
    }
  }

  // static Widget carregando(Color dotsColor, double dotsSize) {
  //   return Center(
  //     child: Container(
  //       alignment: Alignment.center,
  //       width: dotsSize + 20,
  //       height: dotsSize + 20,
  //       child: SpinKitChasingDots(
  //         color: dotsColor,
  //         size: dotsSize,
  //       ),
  //     ),
  //   );
  // }
}



// buildLoading() {
//   return Get.dialog(Center(
//           child: CircularProgressIndicator(
//             valueColor: AlwaysStoppedAnimation<Color>(ColorTheme.use.secondary900),
//           ),
//         ), barrierDismissible: false);
// }


