import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uber_app/views/screens/productDetail/widget/productDetailModel.dart';

class VendorStoreDetail extends StatelessWidget {
  final dynamic vendorData;

  const VendorStoreDetail({super.key, required this.vendorData});
  @override
  Widget build(BuildContext context) {
    double baseWidth = 428;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
        .collection('orders')
        .where('vendorId', isEqualTo: vendorData['vendorId'])
        .snapshots();
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('approved', isEqualTo: true)
        .where('vendorId', isEqualTo: vendorData['vendorId'])
        .snapshots();
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
      stream: _productsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LinearProgressIndicator(
              color: Colors.pink,
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Center(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.cancel,
                        size: 35,
                      ),
                    ),
                    SizedBox(
                      width: 90,
                    ),
                    Center(
                      child: CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(vendorData['storeImage']),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  vendorData['bussinessName'],
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: _ordersStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading");
                      }
                      double totalOrder = 0.0;
                      for (var orderItem in snapshot.data!.docs) {
                        totalOrder +=
                            orderItem['quantity'] * orderItem['productPrice'];
                      }

                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'Total Order',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data!.docs.length.toString(),
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.pink,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Total Earned',
                                      style: TextStyle(
                                        fontSize: 20,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '\$' +
                                          ' ' +
                                          totalOrder.toStringAsFixed(2),
                                      style: TextStyle(
                                        color: Colors.pink,
                                        fontSize: 19,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            snapshot.data!.size >= 4
                                ? Row(
                                    children: [
                                      Text(
                                        'verified',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      Icon(
                                        Icons.verified,
                                        color: Colors.pink,
                                      ),
                                    ],
                                  )
                                : Text(
                                    'Not verified',
                                    style: TextStyle(
                                      fontSize: 20,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              Container(
                height: 500,
                child: ListView.builder(
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    final prouctData = snapshot.data!.docs[index];
                    return SingleChildScrollView(
                        child: ProductDetailModel(
                            prouctData: prouctData, fem: fem));
                  },
                ),
              ),
            ],
          ),
        );
      },
    ));
  }
}
