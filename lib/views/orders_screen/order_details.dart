import 'package:boats_line/consts/consts.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;

import 'componants/order_place_details.dart';
import 'componants/order_staus.dart';

class OrdersDetails extends StatelessWidget {
  final dynamic data;
  const OrdersDetails({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Order Details"
            .text
            .fontFamily(semibold)
            .color(darkFontGrey)
            .make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(children: [
            orderStatus(
                color: redColor,
                icon: Icons.done,
                title: "Placed",
                showDone: data['order_placed']),
            orderStatus(
                color: Colors.blue,
                icon: Icons.thumb_up,
                title: "Confirmed",
                showDone: data['order_confirmed']),
            orderStatus(
                color: Colors.yellow,
                icon: Icons.car_rental,
                title: "On Delivery",
                showDone: data['order_on_delivery']),
            orderStatus(
                color: Colors.green,
                icon: Icons.done_all_rounded,
                title: "Delivered",
                showDone: data['order_delivered']),
            const Divider(),
            10.heightBox,
            orderPlaceDetails(
              d1: data['order_code'],
              d2: data['shipping_method'],
              title1: "Order Code",
              title2: "Shipping Method",
            ),
            orderPlaceDetails(
              d1: intl.DateFormat()
                  .add_yMd()
                  .format((data['order_date'].toDate())),
              d2: data['payment_method'],
              title1: "Order Date",
              title2: "Payment Method",
            ),
            orderPlaceDetails(
              d1: "Unpaid",
              d2: "Order Placed",
              title1: "Payment Status",
              title2: "Delivery Status",
            ),
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Shipping Address".text.fontFamily(semibold).make(),
                            "${data['order_by_name']}".text.make(),
                            "${data['order_by_email']}".text.make(),
                            "${data['order_by_address']}".text.make(),
                            "${data['order_by_city']}".text.make(),
                            "${data['order_by_state']}".text.make(),
                            "${data['order_by_phone']}".text.make(),
                            "${data['order_by_postalcode']}".text.make(),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 115,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Total Amount".text.fontFamily(semibold).make(),
                            "${data['total_amount']}"
                                .text
                                .color(redColor)
                                .fontFamily(bold)
                                .make(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ).box.outerShadowMd.white.make(),
            const Divider(),
            10.heightBox,
            "Order Products"
                .text
                .size(16)
                .color(darkFontGrey)
                .fontFamily(semibold)
                .makeCentered(),
            15.heightBox,
            ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: List.generate(data['orders'].length, (index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    orderPlaceDetails(
                      title1: data['orders'][index]['title'],
                      title2: data['orders'][index]['tprice'],
                      d1: "Units/${data['orders'][index]['qty']}",
                      d2: "Color:",
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 95),
                      child: Container(
                        width: 35,
                        height: 10,
                        color: Color(int.parse(data['orders'][index]['color'],
                            radix: 16)),
                      ),
                    ),
                    const Divider(),
                  ],
                );
              }).toList(),
            )
                .box
                .white
                .shadowMd
                .margin(const EdgeInsets.only(bottom: 4))
                .make(),
            20.heightBox,
          ]),
        ),
      ),
    );
  }
}
