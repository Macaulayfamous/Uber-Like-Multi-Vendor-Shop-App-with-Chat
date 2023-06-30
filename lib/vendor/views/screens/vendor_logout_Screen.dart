import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uber_app/vendor/views/auth/vendor_auth.dart';

class VendorLogoutScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () async {
          _auth.signOut().whenComplete(() {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return VendorAuthScreen();
            }));
          });
        },
        child: Text(
          'Signout',
        ),
      ),
    );
  }
}
