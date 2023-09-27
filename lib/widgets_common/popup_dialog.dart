import 'package:boats_line/consts/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RatingReview {
  final String userId;
  final int rating;
  final String review;
  final DateTime timestamp;

  RatingReview({
    required this.userId,
    required this.rating,
    required this.review,
    required this.timestamp,
  });
}

Widget popupDialog(BuildContext context, String productId, String userId) {
  int selectedRating = 0; // Initially no stars are selected
  TextEditingController reviewController = TextEditingController();

  return AlertDialog(
    title: const Text('Select rating and write review'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        VxRating(
          onRatingUpdate: (rating) {
            // Handle the rating selection
            selectedRating = double.parse(rating).round();
          },
          count: 5, // Number of stars
          stepInt: true,
          value: selectedRating.toInt(), // Current rating value
          size: 30, // Size of each star

          selectionColor: Colors.amber, // Color of selected stars
          normalColor: Colors.grey, // Color of unselected stars
        ),
        const SizedBox(height: 16.0),
        TextField(
          controller: reviewController,
          decoration: const InputDecoration(
            labelText: 'Enter Review',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () async {
            final ratingReview = RatingReview(
              userId: userId,
              rating: selectedRating.toInt(),
              review: reviewController.text,
              timestamp: DateTime.now(),
            );

            // Store the rating and review in Firebase
            await FirebaseFirestore.instance
                .collection('products')
                .doc(productId)
                .collection('ratingsAndReviews')
                .add({
              'userId': ratingReview.userId,
              'rating': ratingReview.rating,
              'review': ratingReview.review,
              'timestamp': ratingReview.timestamp,
            });

            // Close the dialog
            // ignore: use_build_context_synchronously
            Navigator.of(context).pop();
          },
          child: const Text('Submit Review'),
        ),
      ],
    ),
  );
}
