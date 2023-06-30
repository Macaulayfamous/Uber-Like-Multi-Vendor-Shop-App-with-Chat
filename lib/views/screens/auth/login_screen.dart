import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uber_app/views/screens/auth/register_screen.dart';
import 'package:uber_app/views/screens/map_screen.dart';

import '../../../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AuthController _authController = AuthController.instance;

  bool _isLoading = false;

  late String email;

  late String password;

  loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await _authController.loginUser(email, password);
    setState(() {
      _isLoading = false;
    });

    if (res == 'success') {
      Get.offAll(MapScreen());
      Get.snackbar(
        'Success',
        'Logged In',
        colorText: Colors.white,
        backgroundColor: Colors.pink.shade900,
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
                    'Login Account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                  SizedBox(
                    height: 25,
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
                          loginUser();
                        } else {
                          Get.snackbar('Error validating Fields',
                              'Feilds Must Not Be Empty');
                        }
                      },
                      child: _isLoading
                          ? CircularProgressIndicator(
                              color: Colors.cyan,
                            )
                          : Text(
                              'LOGIN',
                            ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(MapScreen());
                    },
                    child: Text(
                      'continue as guest',
                      style: TextStyle(
                        fontSize: 18,
                        letterSpacing: 5,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(RegisterScreen());
                    },
                    child: Text(
                      'Need a customer Account',
                      style: TextStyle(
                        fontSize: 18,
                        letterSpacing: 5,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) {
                      //   return VendorAuthScreen();
                      // }));
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
