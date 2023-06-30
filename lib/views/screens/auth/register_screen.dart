import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../controllers/auth_controller.dart';
import '../../../vendor/views/auth/vendor_auth.dart';
import '../map_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AuthController _authController = AuthController();

  Uint8List? _image;
  bool _isLoading = false;

  late String firstName;

  late String lastName;

  late String email;

  late String password;

  selectGalleryImage() async {
    Uint8List im = await _authController.pickProfileImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  registerUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await _authController.createUser(
      firstName,
      lastName,
      email,
      password,
      _image,
    );
    setState(() {
      _isLoading = false;
    });

    if (res == 'success') {
      Get.to(LoginScreen());
      Get.snackbar(
        'Success',
        'Congratulations Account has been Created For You',
        colorText: Colors.white,
        backgroundColor: Colors.pink,
        margin: EdgeInsets.all(15),
        icon: Icon(
          Icons.message,
          color: Colors.white,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } else {
      Get.snackbar(
        'Error Ocurred',
        res.toString(),
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.red,
        margin: EdgeInsets.all(15),
        icon: Icon(
          Icons.message,
          color: Colors.white,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Register to Maclaystore',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Stack(
                    children: [
                      _image == null
                          ? CircleAvatar(
                              radius: 64,
                              child: Icon(
                                Icons.person,
                                size: 70,
                              ),
                            )
                          : CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_image!),
                            ),
                      Positioned(
                        right: 0,
                        child: IconButton(
                          onPressed: () {
                            selectGalleryImage();
                          },
                          icon: Icon(
                            Icons.photo,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          onChanged: (value) {
                            firstName = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please First Name Must not be Empty';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'First Name',
                            labelStyle: TextStyle(
                              letterSpacing: 4,
                              fontWeight: FontWeight.bold,
                            ),
                            prefixIcon: Icon(
                              Icons.person,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: TextFormField(
                          onChanged: (value) {
                            lastName = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Last Name Must Not Be empty';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                            labelStyle: TextStyle(
                              letterSpacing: 4,
                              fontWeight: FontWeight.bold,
                            ),
                            prefixIcon: Icon(
                              Icons.person,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      email = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Email Adress Must Not Be empty';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Email Adress',
                      labelStyle: TextStyle(
                        letterSpacing: 4,
                        fontWeight: FontWeight.bold,
                      ),
                      prefixIcon: Icon(
                        Icons.email,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      password = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Password Must Not Be empty';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        letterSpacing: 4,
                        fontWeight: FontWeight.bold,
                      ),
                      prefixIcon: Icon(
                        Icons.lock,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 200,
                    child: OutlinedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          registerUser();
                        } else {
                          Get.snackbar(
                              'Form Not Valid', 'Please Fill in the Fields',
                              snackPosition: SnackPosition.BOTTOM,
                              margin: EdgeInsets.all(15),
                              colorText: Colors.white,
                              backgroundColor: Colors.red);
                        }
                      },
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Text('REGISTER'),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.off(MapScreen());
                    },
                    child: Text(
                      'continue as guest',
                      style: TextStyle(
                        fontSize: 18,
                        letterSpacing: 5,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return LoginScreen();
                      }));
                    },
                    child: Text(
                      'Have a customer Account',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return VendorAuthScreen();
                      }));
                    },
                    child: Text(
                      'Need a Vendor Account',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
