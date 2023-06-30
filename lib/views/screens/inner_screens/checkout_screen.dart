import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:provider/provider.dart';
import 'package:uber_app/views/screens/main_Screen.dart';
import 'package:uuid/uuid.dart';

import '../../../provider/cart_provider.dart';
import 'edit_profile_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    CollectionReference users = FirebaseFirestore.instance.collection('buyers');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.pink,
                title: Text(
                  'Checkout',
                  style: TextStyle(
                    fontSize: 18,
                    letterSpacing: 6,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _cartProvider.getCartItem.length,
                  itemBuilder: (context, index) {
                    final cartData =
                        _cartProvider.getCartItem.values.toList()[index];
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        child: SizedBox(
                          height: 170,
                          child: Row(children: [
                            SizedBox(
                              height: 100,
                              width: 100,
                              child: Image.network(cartData.imageUrl[0]),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartData.productName,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 5,
                                    ),
                                  ),
                                  Text(
                                    '\$' +
                                        " " +
                                        cartData.price.toStringAsFixed(2),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 5,
                                      color: Colors.pink,
                                    ),
                                  ),
                                  OutlinedButton(
                                    onPressed: null,
                                    child: Text(
                                      cartData.productSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ),
                    );
                  }),
              bottomSheet: TextButton(
                onPressed: () {},
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: InkWell(
                    onTap: () {
                      EasyLoading.show(status: 'Placing Order');

                      _cartProvider.getCartItem.forEach((key, item) async {
                        final orderId = Uuid().v4();
                        await _firestore.collection('orders').doc(orderId).set({
                          'orderId': orderId,
                          'vendorId': item.vendorId,
                          'email': data['email'],
                          'placeName': data['placeName'],
                          'buyerId': data['buyerId'],
                          'fullName': data['firstName'],
                          'lastName': data['lastName'],
                          'buyerPhoto': data['userImage'],
                          'productName': item.productName,
                          'productPrice': item.price,
                          'productId': item.productId,
                          'productImage': item.imageUrl,
                          'quantity': item.quantity,
                          'productSize': item.productSize,
                          'scheduleDate': item.scheduleDate,
                          'orderDate': DateTime.now(),
                          'accepted': false,
                        }).whenComplete(() async {
                          if (item.quantity == 80) {
                            await _firestore
                                .collection('products')
                                .doc(item.productId)
                                .update({
                              'bestseller': true,
                            });
                          }

                          if (item.quantity == 15) {
                            await _firestore
                                .collection('products')
                                .doc(item.productId)
                                .update({
                              'trending': true,
                            });
                          }

                          if (item.quantity >= 100) {
                            await _firestore
                                .collection('products')
                                .doc(item.productId)
                                .update({
                              'popular': true,
                            });
                          }
                          if (item.quantity == 20) {
                            await _firestore
                                .collection('products')
                                .doc(item.productId)
                                .update({
                              'recent': true,
                            });
                          }
                          setState(() {
                            _cartProvider.getCartItem.clear();
                          });

                          EasyLoading.dismiss();

                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return MainScreen();
                          }));
                        });
                      });
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'PLACE ORDER',
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 6,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ));
        }

        return Center(
          child: CircularProgressIndicator(
            color: Colors.pink,
          ),
        );
      },
    );
  }
}
