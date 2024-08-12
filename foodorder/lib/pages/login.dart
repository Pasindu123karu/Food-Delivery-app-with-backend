import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodorder/pages/bottomnav.dart';
import 'package:foodorder/pages/forgotpassword.dart';
import 'package:foodorder/pages/signup.dart';
import 'package:foodorder/widget/widget_support.dart';

import '../admin/home_admin.dart';
import 'home.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void userLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNav()),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'No user found';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password.';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xffff9800), Color(0xFFe74b1a)],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)
                ),
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
              child: Column(
                children: [
                  Center(
                    child: Image.asset("images/logon.png", width: MediaQuery.of(context).size.width / 1.5, fit: BoxFit.cover),
                  ),
                  SizedBox(height: 50),
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          Text("Login", style: AppWidget.HeadlineTextFeildStyle()),
                          TextFormField(
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email'; // Check if the email field is empty
                              }
                              // Regular expression for email validation
                              String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                              RegExp regex = RegExp(emailPattern);
                              if (!regex.hasMatch(value)) {
                                return 'Invalid email format'; // Check if the email matches the pattern
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: AppWidget.semiBoldTextFeildStyle(),
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                          ),
                          SizedBox(height: 30),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: AppWidget.semiBoldTextFeildStyle(),
                              prefixIcon: Icon(Icons.password_outlined),
                            ),
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword()));
                            },
                            child: Container(
                              alignment: Alignment.topRight,
                              child: Text("Forgot Password?", style: AppWidget.semiBoldTextFeildStyle()),
                            ),
                          ),
                          SizedBox(height: 80),
                          GestureDetector(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  if (_emailController.text == "admin@gmail.com" && _passwordController.text == "1234") {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeAdmin()));
                                  } else {
                                    userLogin();
                                  }
                                }
                              },
                              child: Material(
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 8),
                                      width: 200,
                                      decoration: BoxDecoration(
                                          color: Color(0Xffff5722),
                                          borderRadius: BorderRadius.circular(20)
                                      ),
                                      child: Center(
                                          child: Text(
                                              "LOGIN",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                  fontFamily: 'Poppins1',
                                                  fontWeight: FontWeight.bold
                                              )
                                          )
                                      )
                                  )
                              )
                          ),
                          SizedBox(height: 40),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                            },
                            child: Text("Don't have an account? Sign up", style: AppWidget.semiBoldTextFeildStyle()),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                            },
                            child: Text(
                              "Skip for Now",
                              style: AppWidget.semiBoldTextFeildStyle2(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
