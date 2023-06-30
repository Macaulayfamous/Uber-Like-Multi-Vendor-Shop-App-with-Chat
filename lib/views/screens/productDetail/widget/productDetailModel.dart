import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:uber_app/provider/favourite_provider.dart';
import 'package:uber_app/views/screens/productDetail/product_detail_screen.dart';

class ProductDetailModel extends StatelessWidget {
  const ProductDetailModel({
    Key? key,
    required this.prouctData,
    required this.fem,
  }) : super(key: key);

  final QueryDocumentSnapshot<Object?> prouctData;
  final double fem;

  @override
  Widget build(BuildContext context) {
    final FavouriteProvider _wishList =
        Provider.of<FavouriteProvider>(context, listen: true);

    return GestureDetector(
      onTap: () {
        Get.to(ProductDetailScreen(productData: prouctData));
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              height: 72 * fem,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xffdddddd)),
                color: Color(0xffffffff),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0f000000),
                    offset: Offset(0 * fem, 4 * fem),
                    blurRadius: 6 * fem,
                  ),
                ],
                borderRadius: BorderRadius.circular(
                    8.0), // Add border radius for a rounded look
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 48 * fem,
                      height: 50 * fem,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            8.0), // Add border radius for a rounded look
                        child: Image.network(
                          prouctData['imageUrl'][0],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          prouctData['productName'],
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.525 * fem,
                            color: Color(0xff000000),
                          ),
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5),
                        Text(
                          '\$${prouctData['productPrice'].toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.pink,
                            letterSpacing: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 15,
            top: 8,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  _wishList.addProductToWish(
                    prouctData['productName'],
                    prouctData['productId'],
                    prouctData['imageUrl'],
                    1,
                    prouctData['quantity'],
                    prouctData['productPrice'],
                    prouctData['vendorId'],
                    '',
                    prouctData['scheduleDate'],
                  );
                },
                icon: _wishList.getwishItem.containsKey(prouctData['productId'])
                    ? Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : Icon(
                        Icons.favorite_border,
                        color: Colors.red,
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
