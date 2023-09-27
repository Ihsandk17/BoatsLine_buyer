import 'package:boats_line/consts/consts.dart';
import 'package:boats_line/views/chat_screen/chat_screen.dart';
import 'package:boats_line/widgets_common/loading_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;

import '../../services/firestore_services.dart';
import '../../widgets_common/text_style.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title:
            "My Messages".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getAllMessages(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return "No messages yet!".text.color(darkFontGrey).makeCentered();
          } else {
            var data = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            var t = data[index]['created_on'] == null
                                ? DateTime.now()
                                : data[index]['created_on'].toDate();
                            var time = intl.DateFormat("h:mma").format(t);

                            return Card(
                              child: ListTile(
                                onTap: () {
                                  Get.to(() => const ChatScreen(), arguments: [
                                    data[index]['friend_name'],
                                    data[index]['toId'],
                                  ]);
                                },
                                leading: const CircleAvatar(
                                  backgroundColor: redColor,
                                  child: Icon(
                                    Icons.person,
                                    color: whiteColor,
                                  ),
                                ),
                                title: "${data[index]['friend_name']}"
                                    .text
                                    .fontFamily(semibold)
                                    .color(darkFontGrey)
                                    .make(),
                                subtitle:
                                    "${data[index]['last_msg']}".text.make(),
                                trailing: normalText(
                                    text: time,
                                    color:
                                        darkFontGrey), // Display the time here
                              ),
                            );
                          }))
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
