import 'dart:async';
import 'package:custom_rating_bar/custom_rating_bar.dart' as rate;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rating_summary/rating_summary.dart';
import 'package:uber_app/views/screens/productDetail/vendor_store_detail_screen.dart';
import 'package:uber_app/views/screens/widgets/inner_chat_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/cupertino.dart';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../provider/app_data.dart';
import '../../../provider/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final dynamic productData;

  ProductDetailScreen({super.key, required this.productData});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  double calculateAverageRating(List<double> ratings) {
    if (ratings.isEmpty) {
      return 0.0;
    }

    double total = 0.0;
    for (double rating in ratings) {
      total += rating;
    }

    return total / ratings.length;
  }

  final String phoneNumber = '+2348149106125';
  final String message = 'Hello from my Flutter app!';
  double bottomPadding = 0;
  late GoogleMapController mapController;
  final Geolocator geolocator = Geolocator();
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  String formatedDate(date) {
    final outPutDateFormate = DateFormat('dd/MM/yyyy');

    final outPutDate = outPutDateFormate.format(date);

    return outPutDate;
  }

  void callSeller(String phoneNumber) async {
    final String url = 'tel:$phoneNumber';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(
          url,
        ),
      );
    } else {
      throw 'Could not launch phone call';
    }
  }

  int _imageIndex = 0;
  String? _selectedSize;
  @override
  Widget build(BuildContext context) {
    double? latitude = Provider.of<AppData>(context).pickUpAddress!.latitude;

    double? logitude = Provider.of<AppData>(context).pickUpAddress!.longitude;
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    LatLng customerLatLng = LatLng(
        latitude!, logitude!); // Replace with customer address coordinates
    LatLng vendorLatLng =
        LatLng(widget.productData['latitude'], widget.productData['longitude']);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          title: Text(
            widget.productData['productName'],
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 5,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      child: PhotoView(
                        imageProvider: NetworkImage(
                          widget.productData['imageUrl'][_imageIndex],
                        ),
                      )),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.productData['imageUrl'].length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _imageIndex = index;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                    color: Colors.pink.shade900,
                                  )),
                                  height: 60,
                                  width: 60,
                                  child: Image.network(
                                      widget.productData['imageUrl'][index]),
                                ),
                              ),
                            );
                          }),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.productData['productName'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '\$' +
                          widget.productData['productPrice'].toStringAsFixed(3),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ExpansionTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Product Description',
                            style: TextStyle(
                              color: Colors.pink,
                            ),
                          ),
                          Text(
                            'View More',
                            style: TextStyle(
                              color: Colors.pink,
                            ),
                          ),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.productData['description'],
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                              letterSpacing: 3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    widget.productData['category'] == 'clothes' ||
                            widget.productData['category'] == 'shoes'
                        ? ExpansionTile(
                            title: Text(
                              'VARIATION AVAILABLE',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            children: [
                              Container(
                                height: 50,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        widget.productData['sizeList'].length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          color: _selectedSize ==
                                                  widget.productData['sizeList']
                                                      [index]
                                              ? Colors.pink
                                              : null,
                                          child: OutlinedButton(
                                            onPressed: () {
                                              setState(() {
                                                _selectedSize = widget
                                                        .productData['sizeList']
                                                    [index];
                                              });

                                              print(_selectedSize);
                                            },
                                            child: Text(
                                              widget.productData['sizeList']
                                                  [index],
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              )
                            ],
                          )
                        : SizedBox(),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return VendorStoreDetail(
                      vendorData: widget.productData,
                    );
                  }));
                },
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    widget.productData['storeImage'],
                  ),
                ),
                title: Text(
                  widget.productData['bussinessName'].toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                subtitle: Text(
                  'SEE PROFILE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('productReviews')
                    .where('productId',
                        isEqualTo: widget.productData['productId'])
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<double> ratings = [];
                    if (snapshot.data!.docs.isEmpty) {
                      // No reviews available

                      return Center(
                        child: Text(
                          'No Review For this Product Yet',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink,
                          ),
                        ),
                      );
                    } else {
                      // Reviews are available
                      for (var doc in snapshot.data!.docs) {
                        double rating = doc['rating'];
                        ratings.add(
                          rating,
                        );
                      }

                      double averageRating = calculateAverageRating(ratings);
                      int totalReviews = ratings.length;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            RatingSummary(
                              counter: totalReviews,
                              average: averageRating,
                              showAverage: true,
                              counterFiveStars: 5,
                              counterFourStars: 4,
                              counterThreeStars: 2,
                              counterTwoStars: 1,
                              counterOneStars: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                height: 50,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: ((context, index) {
                                    final mainData = snapshot.data!.docs[index];
                                    return Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            mainData['buyerPhoto'],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          mainData['fullName'],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          ':',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.pink,
                                          ),
                                        ),
                                        Text(
                                          mainData['review'],
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        rate.RatingBar.readOnly(
                                          filledIcon: Icons.star,
                                          emptyIcon: Icons.star_border,
                                          initialRating: mainData['rating'],
                                          maxRating: 5,
                                        )
                                      ],
                                    );
                                  }),
                                  separatorBuilder: (_, index) => SizedBox(
                                    width: 20,
                                  ),
                                  itemCount: snapshot.data!.docs.length,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  } else if (snapshot.hasError) {
                    // Error in retrieving data
                    return Text('Error: ${snapshot.error}');
                  }

                  // Data is still loading
                  return CircularProgressIndicator();
                },
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 280,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: GoogleMap(
                    polylines: {
                      Polyline(
                        polylineId: PolylineId('customer_vendor_id'),
                        points: [
                          customerLatLng,
                          vendorLatLng,
                        ],
                        color: Colors.pink,
                        width: 4,
                      )
                    },
                    markers: Set<Marker>.from([
                      Marker(
                        markerId: MarkerId('seller_store'),
                        position: LatLng(widget.productData['latitude'],
                            widget.productData['longitude']),
                        infoWindow: InfoWindow(title: 'Seller Location'),
                        onTap: () {
                          // Handle marker tap event
                        },
                      ),
                    ]),
                    circles: Set<Circle>.from([
                      Circle(
                        circleId: CircleId(
                            'circle_1'), // Provide a unique ID for the circle
                        center: LatLng(
                            widget.productData['latitude'],
                            widget.productData[
                                'longitude']), // Set the center position of the circle
                        radius: 1000, // Set the radius of the circle in meters
                        fillColor: Colors.pink.withOpacity(
                            0.2), // Set the fill color of the circle
                        strokeColor:
                            Colors.pink, // Set the stroke color of the circle
                        strokeWidth: 2, // Set the stroke width of the circle
                      ),
                    ]),
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                        zoom: 14,
                        target: LatLng(widget.productData['latitude'],
                            widget.productData['longitude'])),
                    onMapCreated: (GoogleMapController controller) {
                      setState(() {
                        _controller.complete(controller);
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 70,
              ),
            ],
          ),
        ),
        bottomSheet: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: _cartProvider.getCartItem
                          .containsKey(widget.productData['productId'])
                      ? null
                      : () {
                          if (widget.productData['category'] != 'clothes') {
                            _cartProvider.addProductToCart(
                                widget.productData['productName'],
                                widget.productData['productId'],
                                widget.productData['imageUrl'],
                                1,
                                widget.productData['quantity'],
                                widget.productData['productPrice'],
                                widget.productData['vendorId'],
                                '',
                                widget.productData['scheduleDate']);

                            Get.snackbar(
                              'ITEM ADDED',
                              'You Added ${widget.productData['productName']} To Your Cart',
                              margin: EdgeInsets.all(20),
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.pink,
                              colorText: Colors.white,
                            );
                          } else {
                            if (_selectedSize == null) {
                              Get.snackbar(
                                'PRODUCT SIZE',
                                'Please Select A Size',
                                margin: EdgeInsets.all(20),
                                backgroundColor: Colors.pink.shade900,
                                colorText: Colors.white,
                              );
                            } else {
                              _cartProvider.addProductToCart(
                                  widget.productData['productName'],
                                  widget.productData['productId'],
                                  widget.productData['imageUrl'],
                                  1,
                                  widget.productData['quantity'],
                                  widget.productData['productPrice'],
                                  widget.productData['vendorId'],
                                  _selectedSize!,
                                  widget.productData['scheduleDate']);

                              Get.snackbar(
                                'ITEM ADDED',
                                'You Added ${widget.productData['productName']} To Your Cart',
                                margin: EdgeInsets.all(20),
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.pink.shade900,
                                colorText: Colors.white,
                              );
                            }
                          }
                        },
                  child: Container(
                    decoration: BoxDecoration(
                      color: _cartProvider.getCartItem
                              .containsKey(widget.productData['productId'])
                          ? Colors.grey
                          : Colors.pink.shade900,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(CupertinoIcons.cart,
                              color: Colors.white, size: 25),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _cartProvider.getCartItem
                                  .containsKey(widget.productData['productId'])
                              ? Text(
                                  'IN CART',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    letterSpacing: 5,
                                  ),
                                )
                              : Text(
                                  'ADD TO CART',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    letterSpacing: 5,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return InnerChatScreen(
                      sellerId: widget.productData['vendorId'],
                      buyerId: FirebaseAuth.instance.currentUser!.uid,
                      productId: widget.productData['productId'],
                      productName: widget.productData['productName'],
                    );
                  }));
                },
                icon: Icon(
                  CupertinoIcons.chat_bubble,
                  color: Colors.pink,
                  size: 30,
                ),
              ),
              IconButton(
                onPressed: () {
                  callSeller('+2348149106125');
                },
                icon: Icon(
                  CupertinoIcons.phone,
                  color: Colors.pink,
                ),
              ),
            ],
          ),
        ));
  }
}

class RatingBar {}
