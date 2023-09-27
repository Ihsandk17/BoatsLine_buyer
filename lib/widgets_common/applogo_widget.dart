import 'package:boats_line/consts/consts.dart';

Widget applogoWidget() {
  //using Velocity X here which is an UI Library

  return Image.asset(icAppLogo)
      .box
      .white
      .size(77, 77)
      .padding(
        const EdgeInsets.all(8),
      )
      .rounded
      .make();
}
