import 'package:boats_line/consts/consts.dart';
import 'package:boats_line/controllers/product_controller.dart';
import 'package:boats_line/widgets_common/our_button.dart';
import 'package:boats_line/widgets_common/rating_stars.dart';
import 'package:boats_line/widgets_common/text_style.dart';
import 'package:get/get.dart';

import '../../widgets_common/popup_dialog.dart';
import '../chat_screen/chat_screen.dart';

class ItemDetails extends StatelessWidget {
  final String? title;
  final dynamic data;
  const ItemDetails({super.key, required this.title, this.data});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());
    // Call calculateAverageRating to update average rating
    controller.calculateAverageRating(data['id']);

    return WillPopScope(
      onWillPop: () async {
        controller.resetValues();
        return true;
      },
      child: Scaffold(
        backgroundColor: lightGrey,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              controller.resetValues();
              Get.back();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: title!.text.color(darkFontGrey).fontFamily(bold).make(),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.share),
            ),
            Obx(
              () => IconButton(
                onPressed: () {
                  if (controller.isFav.value) {
                    controller.removeFromWishlist(data.id, context);
                  } else {
                    controller.addToWishlist(data.id, context);
                  }
                },
                icon: const Icon(Icons.favorite_outlined),
                color: controller.isFav.value ? redColor : darkFontGrey,
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //swiper section
                  VxSwiper.builder(
                      autoPlay: true,
                      height: 350,
                      aspectRatio: 16 / 9,
                      viewportFraction: 1.0,
                      itemCount: data['p_imgs'].length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          data['p_imgs'][index],
                          width: double.infinity,
                          fit: BoxFit.cover,
                        );
                      }),
                  10.heightBox,
                  //title and details section
                  title!.text
                      .size(16)
                      .color(darkFontGrey)
                      .fontFamily(semibold)
                      .make(),
                  10.heightBox,
                  //Price
                  "${data['p_price']}"
                      .numCurrency
                      .numCurrencyWithLocale(locale: "en_US")
                      .text
                      .color(redColor)
                      .size(18)
                      .fontFamily(bold)
                      .make(),
                  10.heightBox,
                  //message
                  Row(
                    children: [
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          "Brand Name".text.white.fontFamily(semibold).make(),
                          5.heightBox,
                          "${data['p_seller']}"
                              .text
                              .fontFamily(semibold)
                              .color(darkFontGrey)
                              .size(16)
                              .make()
                        ],
                      )),
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.message_rounded,
                          color: darkFontGrey,
                        ),
                      ).onTap(() {
                        Get.to(
                          () => const ChatScreen(),
                          arguments: [data['p_seller'], data['vendor_id']],
                        );
                      })
                    ],
                  )
                      .box
                      .height(60)
                      .padding(const EdgeInsets.symmetric(horizontal: 16))
                      .color(textfieldGrey)
                      .make(),

                  20.heightBox,
                  //color section
                  Obx(
                    () => Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: "Color: ".text.color(textfieldGrey).make(),
                            ),
                            Row(
                              children: List.generate(
                                data['p_colors'].length,
                                (index) => Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    VxBox()
                                        .size(40, 40)
                                        .roundedFull
                                        //converts the hexadecimal string to an integer using base 16
                                        .color(Color(int.parse(
                                                data['p_colors'][index],
                                                radix: 16))
                                            .withOpacity(1.0))
                                        .margin(const EdgeInsets.symmetric(
                                            horizontal: 4))
                                        .make()
                                        .onTap(() {
                                      controller.changeColorIndex(index);
                                    }),
                                    Visibility(
                                        visible: index ==
                                            controller.colorIndex.value,
                                        child: const Icon(
                                          Icons.done,
                                          color: Colors.white,
                                        ))
                                  ],
                                ),
                              ),
                            )
                          ],
                        ).box.padding(const EdgeInsets.all(8)).make(),
                        //Quantity Row
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child:
                                  "Quantity: ".text.color(textfieldGrey).make(),
                            ),
                            Obx(
                              () => Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        controller.decreaseQuantity();
                                        controller.calculatTotalPrice(
                                            int.parse(data['p_price']));
                                      },
                                      icon: const Icon(Icons.remove)),
                                  controller.quantity.value.text
                                      .size(16)
                                      .color(darkFontGrey)
                                      .fontFamily(bold)
                                      .make(),
                                  IconButton(
                                      onPressed: () {
                                        controller.increaseQuantity(
                                            int.parse(data['p_quantity']));
                                        controller.calculatTotalPrice(
                                            int.parse(data['p_price']));
                                      },
                                      icon: const Icon(Icons.add)),
                                  10.widthBox,
                                  "${data['p_quantity']} stock"
                                      .text
                                      .color(textfieldGrey)
                                      .make(),
                                ],
                              ),
                            )
                          ],
                        ).box.padding(const EdgeInsets.all(8)).make(),

                        //Total price Row
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: "Total: ".text.color(textfieldGrey).make(),
                            ),
                            "${controller.totalPrice.value}"
                                .numCurrency
                                .text
                                .color(redColor)
                                .fontFamily(bold)
                                .size(16)
                                .make()
                          ],
                        ).box.padding(const EdgeInsets.all(8)).make(),
                        10.heightBox,
                      ],
                    ).box.white.shadowSm.make(),
                  ),
                  10.heightBox,
                  boldText(text: "Category:", color: darkFontGrey, size: 16),
                  10.heightBox,
                  Row(
                    children: [
                      normalText(
                          text: "${data['p_category']}",
                          color: darkFontGrey,
                          size: 14.0),
                      10.widthBox,
                      normalText(
                          text: "${data['p_subcategory']}",
                          color: darkFontGrey,
                          size: 14.0),
                    ],
                  ),
                  10.heightBox,
                  //Discreption section
                  "Discreption"
                      .text
                      .size(16)
                      .color(darkFontGrey)
                      .fontFamily(semibold)
                      .make(),
                  10.heightBox,
                  "${data['p_desc']}".text.color(darkFontGrey).make(),
                  10.heightBox,
                  const Divider(),
                  10.heightBox,
                  //Show Rating in stars, in numbersm and total rating
                  FutureBuilder<int>(
                    future: controller.totalRating(data['id']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(); // or a loading indicator
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final numberOfRatings = snapshot.data ?? 0;

                        return RatingStars(
                          rating: controller.averageRating.value,
                          maxRating: 5,
                          numberOfRatings: numberOfRatings,
                        );
                      }
                    },
                  ),

                  10.heightBox,
                  ElevatedButton(
                    onPressed: () {
                      // Show the popup when the button is pressed
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return popupDialog(
                              context, data['id'], currentUser!.uid);
                        },
                      );
                    },
                    child: const Text('Write Review'),
                  ),

                  //Buttons section which show belove the product details
                  // ListView(
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   shrinkWrap: true,
                  //   children: List.generate(
                  //       itemDetailButtonsList.length,
                  //       (index) => ListTile(
                  //             title: itemDetailButtonsList[index]
                  //                 .text
                  //                 .fontFamily(semibold)
                  //                 .color(darkFontGrey)
                  //                 .make(),
                  //             trailing: const Icon(Icons.arrow_forward),
                  //           )),
                  // ),
                  10.heightBox,
                  const Divider(),
                  10.heightBox,
                  //relatedproducts.text
                  customerRevies.text
                      .fontFamily(bold)
                      .size(16)
                      .color(darkFontGrey)
                      .make(),
                  20.heightBox,
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: List.generate(
                  //         6,
                  //         (index) => Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Image.asset(
                  //                   imgP1,
                  //                   width: 150,
                  //                   fit: BoxFit.cover,
                  //                 ),
                  //                 10.heightBox,
                  //                 "Laptop 4GB/64GB"
                  //                     .text
                  //                     .fontFamily(semibold)
                  //                     .color(darkFontGrey)
                  //                     .make(),
                  //                 10.heightBox,
                  //                 "\$600"
                  //                     .text
                  //                     .color(redColor)
                  //                     .fontFamily(bold)
                  //                     .size(16)
                  //                     .make(),
                  //               ],
                  //             )
                  //                 .box
                  //                 .margin(
                  //                     const EdgeInsets.symmetric(horizontal: 4))
                  //                 .white
                  //                 .roundedSM
                  //                 .padding(const EdgeInsets.all(8))
                  //                 .make()),
                  //   ),
                  // ),
                ],
              )),
            )),
            //add to cart button on item details page
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ourButton(
                color: redColor,
                onPress: () {
                  if (controller.quantity.value > 0) {
                    controller.addToCart(
                        color: data['p_colors'][controller.colorIndex.value],
                        context: context,
                        vendorID: data['vendor_id'],
                        img: data['p_imgs'][0],
                        qty: controller.quantity.value,
                        sellername: data['p_seller'],
                        title: data['p_name'],
                        tprice: controller.totalPrice.value);
                    VxToast.show(context, msg: "Added to cart");
                  } else {
                    VxToast.show(context,
                        msg: "Minimun 1 product is required!");
                  }
                },
                textColor: whiteColor,
                title: "Add to cart",
              ),
            )
          ],
        ),
      ),
    );
  }
}
