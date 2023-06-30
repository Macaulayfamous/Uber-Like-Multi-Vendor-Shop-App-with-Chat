import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class CustomerOrderScreen extends StatefulWidget {
  @override
  State<CustomerOrderScreen> createState() => _CustomerOrderScreenState();
}

class _CustomerOrderScreenState extends State<CustomerOrderScreen> {
  double rating = 0;

  final TextEditingController _reviewTextController = TextEditingController();

  String formatedDate(date) {
    final outPutDateFormate = DateFormat('dd/MM/yyyy');
    final outPutDate = outPutDateFormate.format(date);
    return outPutDate;
  }

  Future<bool> hasUserReviewedProduct(String productId) async {
    final user = FirebaseAuth.instance.currentUser;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('productReviews')
        .where('productId', isEqualTo: productId)
        .where('buyerId', isEqualTo: user!.uid)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
        .collection('orders')
        .where('buyerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade900,
        elevation: 0,
        title: Text(
          'My Orders',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 5,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _ordersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.pink.shade900),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 14,
                      child: document['accepted'] == true
                          ? Icon(Icons.delivery_dining)
                          : Icon(Icons.access_time),
                    ),
                    title: document['accepted'] == true
                        ? Text(
                            'Accepted',
                            style: TextStyle(color: Colors.pink.shade900),
                          )
                        : Text(
                            'Not Accepted',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                    trailing: Text(
                      'Amount' +
                          ' ' +
                          document['productPrice'].toStringAsFixed(2),
                      style: TextStyle(fontSize: 17, color: Colors.pink),
                    ),
                    subtitle: Text(
                      formatedDate(
                        document['orderDate'].toDate(),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                  ),
                  ExpansionTile(
                    title: Text(
                      'Order Details',
                      style: TextStyle(
                        color: Colors.pink.shade900,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text('View Order Details'),
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          child: Image.network(
                            document['productImage'][0],
                          ),
                        ),
                        title: Text(document['productName']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  ('Quantity'),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  document['quantity'].toString(),
                                ),
                              ],
                            ),
                            document['accepted'] == true
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('Schedule Delivery Date'),
                                      Text(formatedDate(
                                          document['scheduleDate'].toDate()))
                                    ],
                                  )
                                : Text(''),
                            ListTile(
                              title: Text(
                                'Buyer Details',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(document['fullName']),
                                  Text(document['email']),
                                  Text(document['placeName']),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final productId = document['productId'];
                          final hasReviewed =
                              await hasUserReviewedProduct(productId);

                          if (hasReviewed) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Error'),
                                content: Text(
                                    'You have already reviewed this product.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the dialog
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Leave a Review'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      controller: _reviewTextController,
                                      decoration: InputDecoration(
                                        labelText: 'Your Review',
                                      ),
                                      // Add any necessary validation or controller properties
                                      // to handle the review text input
                                      // Example: validator, controller, etc.
                                    ),
                                    RatingBar.builder(
                                      initialRating:
                                          rating, // Set the initial rating value
                                      minRating: 1, // Minimum rating value
                                      maxRating: 5, // Maximum rating value
                                      direction: Axis
                                          .horizontal, // Horizontal or vertical display of rating stars
                                      allowHalfRating:
                                          true, // Allow half-star ratings
                                      itemCount:
                                          5, // Number of rating stars to display
                                      itemSize: 24, // Size of each rating star
                                      unratedColor:
                                          Colors.grey, // Color of unrated stars
                                      itemPadding: EdgeInsets.symmetric(
                                          horizontal:
                                              4.0), // Padding between rating stars
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ), // Custom builder for rating star widget
                                      onRatingUpdate: (value) {
                                        rating = value;

                                        // Handle the rating update here
                                        // This callback will be triggered when the user updates the rating
                                        print(rating);
                                      },
                                    )
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      // Save the review and perform any necessary actions
                                      // Example: Call a function to save the review to the database

                                      final review = _reviewTextController.text;

                                      await FirebaseFirestore.instance
                                          .collection('productReviews')
                                          .add({
                                        'productId': productId,
                                        'fullName': document['fullName'],
                                        'buyerPhoto': document['buyerPhoto'],
                                        'email': document['email'],
                                        'buyerId': FirebaseAuth
                                            .instance.currentUser!.uid,
                                        'rating': rating,
                                        'review': review,
                                        'timestamp': Timestamp.now(),
                                      }).whenComplete(() {});

                                      Navigator.pop(
                                          context); // Close the dialog
                                      _reviewTextController.clear();
                                      rating = 0;
                                    },
                                    child: Text('Submit'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: Text('Leave a Review'),
                      ),
                    ],
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
