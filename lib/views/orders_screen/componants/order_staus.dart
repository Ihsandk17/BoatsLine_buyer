import 'package:boats_line/consts/consts.dart';

Widget orderStatus({icon, color, title, showDone}) {
  return ListTile(
    leading: Icon(
      icon,
      color: color,
    )
        .box
        .border(color: color)
        .rounded
        .padding(const EdgeInsets.all(2.0))
        .make(),
    trailing: SizedBox(
      height: 80,
      width: 100,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        "$title".text.color(darkFontGrey).make(),
        showDone
            ? const Icon(
                Icons.done,
                color: redColor,
              )
            : Container(),
      ]),
    ),
  );
}
