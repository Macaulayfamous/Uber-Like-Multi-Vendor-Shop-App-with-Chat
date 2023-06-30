import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../provider/app_data.dart';
import '../../../provider/product_provider.dart';
import 'main_vendor_screen.dart';
import 'upload_tap_screens/attributes_tab_screens.dart';
import 'upload_tap_screens/general_screen.dart';
import 'upload_tap_screens/images_tab_screen.dart';
import 'upload_tap_screens/shipping_screen.dart';

class UploadScreen extends StatefulWidget {
  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Widget build(BuildContext context) {
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);

    double? latitude = Provider.of<AppData>(context).pickUpAddress!.latitude;

    double? logitude = Provider.of<AppData>(context).pickUpAddress!.longitude;

    String? placeName = Provider.of<AppData>(context).pickUpAddress!.placeName;

    return DefaultTabController(
      length: 5,
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.yellow.shade900,
            elevation: 0,
            bottom: TabBar(tabs: [
              Tab(
                child: Text('General'),
              ),
              Tab(
                child: Text('Shipping'),
              ),
              Tab(
                child: Text('Attribute'),
              ),
              Tab(
                child: Text('Images'),
              ),
              Tab(
                child: Text('Video'),
              ),
            ]),
          ),
          body: TabBarView(children: [
            GeneralScreen(),
            ShippingScreeen(),
            AttributesTabScreen(),
            ImagesTabScreen(),
          ]),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.yellow.shade900,
              ),
              onPressed: () async {
                DocumentSnapshot userDoc = await _firestore
                    .collection('vendors')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .get();
                EasyLoading.show(status: 'Please Wait...');
                if (_formKey.currentState!.validate()) {
                  final productId = Uuid().v4();
                  await _firestore.collection('products').doc(productId).set({
                    'latitude': latitude,
                    'longitude': logitude,
                    'placeName': placeName,
                    'bussinessName': (userDoc.data()
                        as Map<String, dynamic>)['bussinessName'],
                    'countryValue': (userDoc.data()
                        as Map<String, dynamic>)['countryValue'],
                    'storeImage':
                        (userDoc.data() as Map<String, dynamic>)['storeImage'],
                    'productId': productId,
                    'productName': _productProvider.productData['productName'],
                    'bestseller': false,
                    'popular': false,
                    'recent': false,
                    'trending': false,
                    'productPrice':
                        _productProvider.productData['productPrice'],
                    'quantity': _productProvider.productData['quantity'],
                    'category': _productProvider.productData['category'],
                    'description': _productProvider.productData['description'],
                    'imageUrl': _productProvider.productData['imageUrlList'],
                    'scheduleDate':
                        _productProvider.productData['scheduleDate'],
                    'chargeShipping':
                        _productProvider.productData['chargeShipping'],
                    'shippingCharge':
                        _productProvider.productData['shippingCharge'],
                    'brandName': _productProvider.productData['brandName'],
                    'sizeList': _productProvider.productData['sizeList'],
                    'videoUrl': _productProvider.productData['videoUrl'] == null
                        ? ''
                        : _productProvider.productData['videoUrl'],
                    'vendorId': FirebaseAuth.instance.currentUser!.uid,
                    'approved': false,
                  }).whenComplete(() {
                    _productProvider.clearData();
                    _formKey.currentState!.reset();
                    EasyLoading.dismiss();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return MainVendorScreen();
                    }));
                  });
                }
              },
              child: Text('Save'),
            ),
          ),
        ),
      ),
    );
  }
}
