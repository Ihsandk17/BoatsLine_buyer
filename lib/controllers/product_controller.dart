import 'package:boats_line/consts/consts.dart';
import 'package:boats_line/models/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  RxDouble averageRating = 0.0.obs; // Rx variable to store average rating

  var quantity = 0.obs;
  var colorIndex = 0.obs;
  var totalPrice = 0.obs;

  var subcat = [];

  var isFav = false.obs;

  getSubCategories(title) async {
    subcat.clear();
    var data = await rootBundle.loadString("lib/services/category_model.json");
    var decoded = categoryModelFromJson(data);
    var s =
        decoded.categories.where((element) => element.name == title).toList();
    for (var e in s[0].subcategory) {
      subcat.add(e);
    }
  }

  changeColorIndex(index) {
    colorIndex.value = index;
  }

  increaseQuantity(totalQuantity) {
    if (quantity.value < totalQuantity) {
      quantity.value++;
    }
  }

  decreaseQuantity() {
    if (quantity.value > 0) {
      quantity.value--;
    }
  }

  calculatTotalPrice(price) {
    totalPrice.value = price * quantity.value;
  }

  addToCart(
      {title, img, sellername, color, qty, tprice, context, vendorID}) async {
    await firestore.collection(cartCollection).doc().set({
      'title': title,
      'img': img,
      'sellername': sellername,
      'color': color,
      'qty': qty,
      'vendor_id': vendorID,
      'tprice': tprice,
      'added_by': currentUser!.uid,
    }).catchError((error) {
      VxToast.show(context, msg: error.toString());
    });
  }

  //reset add to cart values press on back button
  resetValues() {
    totalPrice.value = 0;
    quantity.value = 0;
    colorIndex.value = 0;
  }

  addToWishlist(docId, context) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayUnion([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(true);
    VxToast.show(context, msg: "Added in wishlist");
  }

  removeFromWishlist(docId, context) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(false);
    VxToast.show(context, msg: "Remove from wishlist");
  }

  //check product is available in wishlist or not
  checkIfFav(data) async {
    if (data['p_wishlist'].contains(currentUser!.uid)) {
      isFav(true);
    } else {
      isFav(false);
    }
  }

  //calculate Average rating
  calculateAverageRating(String productId) {
    final ratingsRef = FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .collection('ratingsAndReviews');

    ratingsRef.get().then((querySnapshot) {
      if (querySnapshot.size == 0) {
        // No ratings and reviews available
        averageRating.value = 0.0; // Set to 0 if no ratings exist
      } else {
        double totalRating = 0.0;
        int numberOfRatings = 0;

        // ignore: avoid_function_literals_in_foreach_calls
        querySnapshot.docs.forEach((document) {
          final rating =
              document['rating']; // Replace with the correct field name
          totalRating += rating;
          numberOfRatings++;
        });

        final calculatedAverage = totalRating / numberOfRatings;
        averageRating.value = calculatedAverage;
      }
    }).catchError((error) {
      // ignore: avoid_print
      print("Error calculating average rating: $error");
    });
  }

  // Method to count the number of ratings for a product
  Future<int> totalRating(String productId) async {
    try {
      final ratingsRef = FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .collection('ratingsAndReviews');

      final querySnapshot = await ratingsRef.get();

      return querySnapshot.size;
    } catch (error) {
      // ignore: avoid_print
      print("Error counting ratings: $error");
      return 0; // Return 0 in case of an error
    }
  }
}
