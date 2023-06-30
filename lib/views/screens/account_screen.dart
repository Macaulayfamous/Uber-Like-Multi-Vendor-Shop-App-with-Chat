import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uber_app/views/screens/inner_screens/order_screen.dart';

import 'auth/login_screen.dart';

class AccountScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('buyers');
    return _auth.currentUser == null
        ? Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 2,
              backgroundColor: Colors.pink.shade900,
              title: Text(
                'Profile',
                style: TextStyle(letterSpacing: 4),
              ),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Icon(Icons.star),
                ),
              ],
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 25,
                ),
                Center(
                  child: CircleAvatar(
                    radius: 64,
                    backgroundColor: Colors.pink.shade900,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Login Account TO Access Profile',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return LoginScreen();
                    }));
                  },
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width - 200,
                    decoration: BoxDecoration(
                      color: Colors.pink.shade900,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                        child: Text(
                      'LOGIN ACCOUNT',
                      style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 4,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    )),
                  ),
                ),
              ],
            ),
          )
        : FutureBuilder<DocumentSnapshot>(
            future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                    automaticallyImplyLeading: false,
                    elevation: 2,
                    backgroundColor: Colors.pink.shade900,
                    title: Text(
                      'Profile',
                      style: TextStyle(letterSpacing: 4),
                    ),
                    centerTitle: true,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Icon(Icons.star),
                      ),
                    ],
                  ),
                  body: Column(
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      Center(
                        child: CircleAvatar(
                          radius: 64,
                          backgroundColor: Colors.pink.shade900,
                          backgroundImage: NetworkImage(data['userImage']),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data['firstName'],
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data['email'],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width - 200,
                          decoration: BoxDecoration(
                            color: Colors.pink.shade900,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                              child: Text(
                            'Edit Profile',
                            style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 4,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Divider(
                          thickness: 2,
                          color: Colors.grey,
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('Settings'),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text('Phone'),
                      ),
                      ListTile(
                        leading: Icon(Icons.shop),
                        title: Text('Cart'),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CustomerOrderScreen();
                          }));
                        },
                        leading: Icon(CupertinoIcons.shopping_cart),
                        title: Text('Order'),
                      ),
                      ListTile(
                        onTap: () async {
                          await _auth.signOut().whenComplete(() {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return LoginScreen();
                            }));
                          });
                        },
                        leading: Icon(Icons.logout),
                        title: Text('Logout'),
                      ),
                    ],
                  ),
                );
              }

              return Center(child: CircularProgressIndicator());
            },
          );
  }
}
