import 'package:boats_line/consts/consts.dart';
import 'package:boats_line/consts/lists.dart';
import 'package:boats_line/controllers/profile_controller.dart';
import 'package:boats_line/views/profile_screen/edit_profile_screen.dart';
import 'package:boats_line/widgets_common/bg_widget.dart';
import 'package:boats_line/widgets_common/loading_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../services/firestore_services.dart';
import '../chat_screen/messaging_screen.dart';
import '../orders_screen/orders_screen.dart';
import '../wishlist_screen/wishlist_screen.dart';
import 'components/details_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    // final authCont = Get.put(AuthController());

    return bgWidget(
      child: Scaffold(
        body: StreamBuilder(
          stream: FirestoreServices.getUser(auth.currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: loadingIndicator(),
              );
            } else {
              var data = snapshot.data!.docs[0];

              return SafeArea(
                child: Column(
                  children: [
                    //Edit button
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Align(
                          alignment: Alignment.topRight,
                          child: Icon(
                            Icons.edit,
                            color: whiteColor,
                          )).onTap(() {
                        controller.nameController.text = data['name'];

                        Get.to(() => EditProfileScreen(data: data));
                      }),
                    ),

                    //User details section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          data['imageUrl'] == ''
                              ? Image.asset(
                                  imgProfile2,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ).box.roundedFull.clip(Clip.antiAlias).make()
                              : Image.network(
                                  data['imageUrl'],
                                  width: 100,
                                  fit: BoxFit.cover,
                                ).box.roundedFull.clip(Clip.antiAlias).make(),
                          10.widthBox,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "${data['name']}"
                                    .text
                                    .fontFamily(semibold)
                                    .white
                                    .make(),
                                "${data['email']}".text.white.make()
                              ],
                            ),
                          ),

                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: whiteColor),
                            ),
                            onPressed: () {
                              Get.find<ProfileController>()
                                  .showLogoutConfirmationDialog(context);
                            },
                            child:
                                logout.text.fontFamily(semibold).white.make(),
                          )

                          // OutlinedButton(
                          //     style: OutlinedButton.styleFrom(
                          //         side: const BorderSide(color: whiteColor)),
                          //     onPressed: () async {

                          //       await Get.put(AuthController())
                          //           .signoutMethod(context);

                          //       Get.offAll(() => const LoginScreen());
                          //     },
                          //     child:
                          //         logout.text.fontFamily(semibold).white.make())
                        ],
                      ),
                    ),
                    30.heightBox,

                    FutureBuilder(
                        future: FirestoreServices.getCounts(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: loadingIndicator(),
                            );
                          } else {
                            var countData = snapshot.data;
                            return Container(
                              color: redColor,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  detailsCard(
                                      count: countData[0].toString(),
                                      title: "in cart",
                                      width: context.screenWidth / 3.5),
                                  detailsCard(
                                      count: countData[1].toString(),
                                      title: "in Wish List",
                                      width: context.screenWidth / 3.5),
                                  detailsCard(
                                      count: countData[2].toString(),
                                      title: "in your orders",
                                      width: context.screenWidth / 3.5),
                                ],
                              ),
                            );
                          }
                        }),

                    //Button section
                    ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: lightGrey,
                        );
                      },
                      itemCount: profileButtonsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                            onTap: () {
                              switch (index) {
                                case 0:
                                  Get.to(() => const WishlistScreen());
                                  break;
                                case 1:
                                  Get.to(() => const OrdersScreen());
                                  break;
                                case 2:
                                  Get.to(() => const MessagesScreen());
                                  break;
                              }
                            },
                            leading: Image.asset(
                              profileButtonsIcon[index],
                              width: 22,
                            ),
                            title: profileButtonsList[index]
                                .text
                                .fontFamily(semibold)
                                .color(darkFontGrey)
                                .make());
                      },
                    )
                        .box
                        .white
                        .rounded
                        .margin(const EdgeInsets.all(12))
                        .padding(const EdgeInsets.symmetric(horizontal: 16))
                        .shadowSm
                        .make()
                        .box
                        .color(redColor)
                        .make()
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
