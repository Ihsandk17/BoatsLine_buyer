import 'package:boats_line/consts/consts.dart';
import 'package:boats_line/consts/lists.dart';
import 'package:boats_line/controllers/home_controler.dart';
import 'package:boats_line/services/firestore_services.dart';
import 'package:boats_line/views/category_screen/item_details.dart';
import 'package:boats_line/views/home_screen/search_screen.dart';
import 'package:boats_line/widgets_common/loading_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'components/featured_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<HomeController>();
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(12),
        color: lightGrey,
        width: context.screenWidth,
        height: context.screenHeight,
        child: SafeArea(
          child: Column(
            children: [
              //Search Bar
              Container(
                alignment: Alignment.center,
                height: 60,
                color: lightGrey,
                child: TextFormField(
                  controller: controller.searchController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: const Icon(Icons.search).onTap(() {
                      if (controller
                          .searchController.text.isNotEmptyAndNotNull) {
                        Get.to(
                          () => SearchScreen(
                            title: controller.searchController.text,
                          ),
                        );
                      }
                    }),
                    filled: true,
                    fillColor: whiteColor,
                    hintText: searchanything,
                    hintStyle: const TextStyle(color: textfieldGrey),
                  ),
                ),
              ), //search bar end

              10.heightBox,
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // //swipers brands
                      // VxSwiper.builder(
                      //   aspectRatio: 15 / 9,
                      //   autoPlay: true,
                      //   height: 150,
                      //   enlargeCenterPage: true,
                      //   itemCount: slidersList.length,
                      //   itemBuilder: (context, index) {
                      //     return Image.asset(
                      //       slidersList[index],
                      //       fit: BoxFit.fill,
                      //     )
                      //         .box
                      //         .rounded
                      //         .clip(Clip.antiAlias)
                      //         .margin(const EdgeInsets.symmetric(horizontal: 8))
                      //         .make();
                      //   },
                      // ),

                      10.heightBox,
                      //deals buttons
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: List.generate(
                      //     2,
                      //     (index) => homeButtons(
                      //       height: context.screenHeight * 0.15,
                      //       width: context.screenWidth / 2.5,
                      //       icon: index == 0 ? icTodaysDeal : icFlashDeal,
                      //       title: index == 0 ? todayDeal : flashsale,
                      //     ),
                      //   ),
                      // ),

                      // 10.heightBox,
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: List.generate(
                      //     3,
                      //     (index) => homeButtons(
                      //       height: context.screenHeight * 0.15,
                      //       width: context.screenWidth / 3.5,
                      //       icon: index == 0
                      //           ? icTopCategories
                      //           : index == 1
                      //               ? icBrands
                      //               : icTopSeller,
                      //       title: index == 0
                      //           ? topCategories
                      //           : index == 1
                      //               ? brand
                      //               : topSallers,
                      //     ),
                      //   ),
                      // ),

                      10.heightBox,
                      //featured categories
                      Align(
                        alignment: Alignment.centerLeft,
                        child: featuredCategories.text
                            .color(darkFontGrey)
                            .size(18)
                            .fontFamily(semibold)
                            .make(),
                      ),
                      10.heightBox,
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            3,
                            (index) => Column(
                              children: [
                                featuredButton(
                                    icon: featuredImages1[index],
                                    title: featuredTitle1[index]),
                                10.heightBox,
                                featuredButton(
                                    icon: featuredImages2[index],
                                    title: featuredTitle2[index]),
                              ],
                            ),
                          ),
                        ),
                      ),
                      10.heightBox,
                      //featured Products
                      Container(
                        padding: const EdgeInsets.all(12),
                        width: double.infinity,
                        decoration: const BoxDecoration(color: redColor),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            featuredProduct.text.white
                                .fontFamily(bold)
                                .size(18)
                                .make(),
                            10.heightBox,
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: FutureBuilder(
                                future: FirestoreServices.getFeaturedProducts(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: loadingIndicator(),
                                    );
                                  } else if (snapshot.data!.docs.isEmpty) {
                                    return "No featured products"
                                        .text
                                        .white
                                        .makeCentered();
                                  } else {
                                    var featuredData = snapshot.data!.docs;
                                    return Row(
                                      children: List.generate(
                                          featuredData.length,
                                          (index) => Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Image.network(
                                                    featuredData[index]
                                                        ['p_imgs'][0],
                                                    width: 130,
                                                    height: 130,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  10.heightBox,
                                                  "${featuredData[index]['p_name']}"
                                                      .text
                                                      .fontFamily(semibold)
                                                      .color(darkFontGrey)
                                                      .make(),
                                                  10.heightBox,
                                                  "${featuredData[index]['p_price']}"
                                                      .numCurrency
                                                      .text
                                                      .color(redColor)
                                                      .fontFamily(bold)
                                                      .size(16)
                                                      .make(),
                                                ],
                                              )
                                                  .box
                                                  .margin(const EdgeInsets
                                                      .symmetric(horizontal: 4))
                                                  .white
                                                  .roundedSM
                                                  .padding(
                                                      const EdgeInsets.all(8))
                                                  .make()
                                                  .onTap(() {
                                                Get.to(() => ItemDetails(
                                                      title:
                                                          "${featuredData[index]['p_name']}",
                                                      data: featuredData[index],
                                                    ));
                                              })),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      20.heightBox,
                      // //third swiper
                      // VxSwiper.builder(
                      //   aspectRatio: 16 / 9,
                      //   autoPlay: true,
                      //   height: 150,
                      //   enlargeCenterPage: true,
                      //   itemCount: slidersList.length,
                      //   itemBuilder: (context, index) {
                      //     return Image.asset(
                      //       slidersList[index],
                      //       fit: BoxFit.fill,
                      //     )
                      //         .box
                      //         .rounded
                      //         .clip(Clip.antiAlias)
                      //         .margin(const EdgeInsets.symmetric(horizontal: 8))
                      //         .make();
                      //   },
                      // ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: allproducts.text
                            .color(darkFontGrey)
                            .size(18)
                            .fontFamily(semibold)
                            .make(),
                      ),

                      20.heightBox,
                      //All product section
                      StreamBuilder(
                          stream: FirestoreServices.allProducts(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: loadingIndicator(),
                              );
                            } else {
                              var allproductsdata = snapshot.data!.docs;
                              return GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: allproductsdata.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8,
                                        mainAxisExtent: 300),
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        allproductsdata[index]['p_imgs'][0],
                                        height: 200,
                                        width: 200,
                                        fit: BoxFit.cover,
                                      ),
                                      const Spacer(),
                                      10.heightBox,
                                      "${allproductsdata[index]['p_name']}"
                                          .text
                                          .fontFamily(semibold)
                                          .color(darkFontGrey)
                                          .make(),
                                      10.heightBox,
                                      "${allproductsdata[index]['p_price']}"
                                          .numCurrency
                                          .text
                                          .color(redColor)
                                          .fontFamily(bold)
                                          .size(16)
                                          .make(),
                                    ],
                                  )
                                      .box
                                      .margin(const EdgeInsets.symmetric(
                                          horizontal: 4))
                                      .white
                                      .roundedSM
                                      .padding(const EdgeInsets.all(12))
                                      .make()
                                      .onTap(() {
                                    Get.to(() => ItemDetails(
                                          title:
                                              "${allproductsdata[index]['p_name']}",
                                          data: allproductsdata[index],
                                        ));
                                  });
                                },
                              );
                            }
                          })
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
