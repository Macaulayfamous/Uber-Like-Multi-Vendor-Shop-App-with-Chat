import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../productDetail/widget/productDetailModel.dart';

class HomeproductWidget extends StatelessWidget {
  final String categoryName;

  const HomeproductWidget({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 428;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: categoryName)
        .where('approved', isEqualTo: true)
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _productsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading.....");
        }

        return Container(
            height: 100,
            child: PageView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final prouctData = snapshot.data!.docs[index];
                  return ProductDetailModel(
                    prouctData: prouctData,
                    fem: fem,
                  );
                }));
      },
    );
  }
}
