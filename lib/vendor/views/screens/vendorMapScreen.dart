import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_app/helpers/helper_methods.dart';
import 'package:uber_app/views/screens/main_Screen.dart';

import 'main_vendor_screen.dart';

class MapVendorScreen extends StatefulWidget {
  const MapVendorScreen({super.key});

  @override
  State<MapVendorScreen> createState() => _MapVendorScreenState();
}

class _MapVendorScreenState extends State<MapVendorScreen> {
  double bottomPadding = 0;
  late GoogleMapController mapController;
  final Geolocator geolocator = Geolocator();
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  /// geting user location

  late Position currentPosition;

  setUpPositionLocation() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
      forceAndroidLocationManager: true,
    );

    currentPosition = position;

    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = CameraPosition(target: pos, zoom: 15);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address =
        await HelperMethods.findCordinateAddress(position, context);

    print(address);
    print('ok');
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPadding),
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);

              mapController = controller;

              setState(() {
                bottomPadding = 300;
              });

              setUpPositionLocation();
            },
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 70,
                      child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return MainVendorScreen();
                            }));
                          },
                          icon: Icon(FontAwesomeIcons.stackOverflow),
                          label: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'GO TO DASHBOARD ',
                              style: TextStyle(
                                letterSpacing: 4,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
