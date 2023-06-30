import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uber_app/vendor/views/screens/vendorMapScreen.dart';

import '../../../views/screens/map_screen.dart';
import '../../models/vendor_user_models.dart';
import '../auth/vendor_register_screen.dart';


class LandingScreen extends StatelessWidget {
  static const String routeName = '\landing-screen';

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final CollectionReference _vendorsStream =
        FirebaseFirestore.instance.collection('vendors');
    return Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
      stream: _vendorsStream.doc(_auth.currentUser!.uid).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        if (!snapshot.data!.exists) {
          return VendorRegistrationScreen();
        }

        VendorUserModel vendorUserModel = VendorUserModel.fromJson(
            snapshot.data!.data()! as Map<String, dynamic>);

        if (vendorUserModel.approved == true) {
          return MapVendorScreen();
        }
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                vendorUserModel.storeImage.toString(),
                width: 90,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              vendorUserModel.bussinessName.toString(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Your application has been sent to shop admin\n Admin will get back to you soon',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () async {
                await _auth.signOut();
              },
              child: Text('Signout'),
            ),
          ],
        ));
      },
    ));
  }
}
