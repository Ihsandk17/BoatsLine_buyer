import 'package:boats_line/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import 'consts/consts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const BoatsLine());
}

class BoatsLine extends StatelessWidget {
  const BoatsLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appname,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
            //appBar Icons colors
            iconTheme: IconThemeData(color: darkFontGrey),
            //Set elevation to 0
            elevation: 0.0,
            backgroundColor: Colors.transparent),
        fontFamily: regular,
      ),
      home: const Wrapper(),
    );
  }
}
