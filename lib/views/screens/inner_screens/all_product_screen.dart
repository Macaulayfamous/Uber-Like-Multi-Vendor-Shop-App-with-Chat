import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../productDetail/product_detail_screen.dart';

class AllProductScreen extends StatelessWidget {
  final dynamic categoryData;

  const AllProductScreen({super.key, required this.categoryData});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: categoryData['categoryName'])
        .where('approved', isEqualTo: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.pink.shade900,
        title: Text(
          categoryData['categoryName'],
          style: TextStyle(
            letterSpacing: 6,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _productsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.pink.shade900,
              ),
            );
          }

          return GridView.builder(
              itemCount: snapshot.data!.size,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 200 / 300),
              itemBuilder: (context, index) {
                final productData = snapshot.data!.docs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProductDetailScreen(
                        productData: productData,
                      );
                    }));
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 170,
                              width: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    productData['imageUrl'][0],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            productData['productName'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '\$' +
                                " " +
                                productData['productPrice'].toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4,
                              color: Colors.pink.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
