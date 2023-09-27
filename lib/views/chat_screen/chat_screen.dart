import 'package:boats_line/consts/consts.dart';
import 'package:boats_line/controllers/chats_controller.dart';
import 'package:boats_line/widgets_common/text_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../services/firestore_services.dart';
import '../../widgets_common/loading_indicator.dart';
import 'components/sender_bubble.dart';

// class ChatScreen extends StatelessWidget {
//   const ChatScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var controller = Get.put(ChatsController());
//     return Scaffold(
//       backgroundColor: whiteColor,
//       appBar: AppBar(
//         title: "${controller.friendName}"
//             .text
//             .fontFamily(semibold)
//             .color(darkFontGrey)
//             .make(),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(children: [
//           Obx(
//             () => controller.isLoading.value
//                 ? Center(
//                     child: loadingIndicator(),
//                   )
//                 : Expanded(
//                     child: StreamBuilder(
//                         stream: FirestoreServices.getChatMessages(
//                             controller.chatDocId.toString()),
//                         builder: (BuildContext context,
//                             AsyncSnapshot<QuerySnapshot> snapshot) {
//                           if (!snapshot.hasData) {
//                             return Center(
//                               child: loadingIndicator(),
//                             );
//                           } else if (snapshot.data!.docs.isEmpty) {
//                             return Center(
//                               child: "Send a message..."
//                                   .text
//                                   .color(darkFontGrey)
//                                   .make(),
//                             );
//                           } else {
//                             return ListView(
//                               children: snapshot.data!.docs
//                                   .mapIndexed((currentValue, index) {
//                                 var data = snapshot.data!.docs[index];
//                                 return Align(
//                                     alignment: data['uid'] == currentUser!.uid
//                                         ? Alignment.centerRight
//                                         : Alignment.centerLeft,
//                                     child: senderBubble(data));
//                               }).toList(),
//                             );
//                           }
//                         }),
//                   ),
//           ),
//           10.heightBox,
//           Row(
//             children: [
//               Expanded(
//                   child: TextFormField(
//                 controller: controller.msgController,
//                 decoration: const InputDecoration(
//                     border: OutlineInputBorder(
//                         borderSide: BorderSide(color: textfieldGrey)),
//                     focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: textfieldGrey)),
//                     hintText: "Type a message..."),
//               )),
//               IconButton(
//                 onPressed: () {
//                   controller.sendMsg(controller.msgController.text);
//                   controller.msgController.clear();
//                 },
//                 icon: const Icon(Icons.send),
//                 color: redColor,
//               )
//             ],
//           )
//               .box
//               .height(80)
//               .margin(const EdgeInsets.only(bottom: 8))
//               .padding(const EdgeInsets.all(12))
//               .make()
//         ]),
//       ),
//     );
//   }
// }

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var chatDocId = Get.arguments[1]; // Get the chatDocId from arguments
    var controller =
        Get.put(ChatsController(chatDocId)); // Pass it to the controller

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
          backgroundColor: whiteColor,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: darkFontGrey,
              )),
          title: boldText(
              text: controller.friendName, size: 16.0, color: fontGrey)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Obx(
            () => controller.isLoading.value
                ? Center(
                    child: loadingIndicator(),
                  )
                : Expanded(
                    child: StreamBuilder(
                        stream: FirestoreServices.getChatMessages(
                            controller.chatDocId.toString()),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: loadingIndicator(),
                            );
                          } else if (snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: "Send a message..."
                                  .text
                                  .color(darkFontGrey)
                                  .make(),
                            );
                          } else {
                            return ListView(
                              children: snapshot.data!.docs
                                  .mapIndexed((currentValue, index) {
                                var data = snapshot.data!.docs[index];
                                return Align(
                                    alignment: data['uid'] == currentUser!.uid
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: senderBubble(data));
                              }).toList(),
                            );
                          }
                        }),
                  ),
          ),
          10.heightBox,
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                controller: controller.msgController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: textfieldGrey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: textfieldGrey)),
                    hintText: "Type a message..."),
              )),
              IconButton(
                onPressed: () {
                  controller.sendMsg(controller.msgController.text);
                  controller.msgController.clear();
                },
                icon: const Icon(Icons.send),
                color: redColor,
              )
            ],
          )
              .box
              .height(80)
              .margin(const EdgeInsets.only(bottom: 8))
              .padding(const EdgeInsets.all(12))
              .make()
        ]),
      ),
    );
  }
}
