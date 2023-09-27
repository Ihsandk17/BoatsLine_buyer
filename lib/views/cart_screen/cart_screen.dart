import 'package:boats_line/consts/consts.dart';
import 'package:boats_line/controllers/cart_controller.dart';
import 'package:boats_line/services/firestore_services.dart';
import 'package:boats_line/views/cart_screen/shipping_screen.dart';
import 'package:boats_line/widgets_common/loading_indicator.dart';
import 'package:boats_line/widgets_common/our_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());
    return Scaffold(
      backgroundColor: whiteColor,
      bottomNavigationBar: SizedBox(
        height: 55,
        child: ourButton(
            color: redColor,
            onPress: () {
              Get.to(() => const ShippingDetails());
            },
            textColor: whiteColor,
            title: "Place order"),
      ),
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: "Shopping cart"
              .text
              .fontFamily(semibold)
              .color(darkFontGrey)
              .make()),
      body: StreamBuilder(
        stream: FirestoreServices.getCart(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: "Cart is empty".text.color(darkFontGrey).make(),
            );
          } else {
            var data = snapshot.data!.docs;
            controller.calculate(data);

            controller.productSnapshot = data;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: ((context, index) => ListTile(
                          leading: Image.network(
                            "${data[index]['img']}",
                            width: 80,
                            fit: BoxFit.cover,
                          ),

                          title: "${data[index]['title']} ${data[index]['qty']}"
                              .text
                              .fontFamily(semibold)
                              .size(16)
                              .make(),
                          subtitle: "${data[index]['tprice']}"
                              .numCurrency
                              .text
                              .fontFamily(semibold)
                              .color(redColor)
                              .make(),
                          //button for delete product from cart
                          trailing: const Icon(
                            Icons.delete,
                            color: redColor,
                          ).onTap(() {
                            FirestoreServices.deleteDocument(data[index].id);
                          }),
                        )),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "Total price"
                        .text
                        .fontFamily(semibold)
                        .color(darkFontGrey)
                        .make(),
                    Obx(
                      () => "${controller.totalP.value}"
                          .numCurrency
                          .text
                          .fontFamily(semibold)
                          .color(redColor)
                          .make(),
                    ),
                  ],
                )
                    .box
                    .padding(const EdgeInsets.all(12))
                    .color(lightGolden)
                    .roundedSM
                    .width(context.screenWidth - 60)
                    .make(),
                10.heightBox,
                // SizedBox(
                //   width: context.screenWidth - 60,
                //   child: ourButton(
                //       color: redColor,
                //       onPress: () {},
                //       textColor: whiteColor,
                //       title: "Place order"),
                // ),
              ]),
            );
          }
        },
      ),
    );
  }
}
