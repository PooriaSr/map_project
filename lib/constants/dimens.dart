import 'package:flutter/cupertino.dart';

class Dimens {
  Dimens._();

  static const medium = 12.00;
  static const small = 8.00;
  static const large = 24.00;
  static const xLarge = 32.00;
  static const xxLarge = 48.00;
  static const xxxLarge = 96.00;

  static double phoneWidth(context) {
    return MediaQuery.of(context).size.width;
  }

  static double phoneHeight(context) {
    return MediaQuery.of(context).size.height;
  }
}
