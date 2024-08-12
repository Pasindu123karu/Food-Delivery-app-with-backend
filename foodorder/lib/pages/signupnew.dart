import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'login.dart';
import 'home.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Key for the form

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an address';
    }


    return null;
  }
  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }

    final RegExp phoneRegex = RegExp(r'^\+?\(?\d{10,16}\)?$');

    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }



  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text.trim();
      final String username = _usernameController.text.trim();
      final String password = _passwordController.text.trim();
      final String confirmPassword = _confirmPasswordController.text.trim();
      final String phoneNumber = _phoneNumberController.text.trim();
      final String address = _addressController.text.trim();

      // Hash the password using SHA-256 algorithm
      final hashedPassword =
      sha256.convert(utf8.encode(password)).toString();

      try {
        // Check if the email already exists in the database
        final existingUser = await FirebaseFirestore.instance
            .collection('users')
            .doc(email)
            .get();
        if (existingUser.exists) {
          // Email is already registered, show error message to the user
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text(
                  'Email is already registered. Please use a different email.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            ),
          );
          return;
        }

        // Email is unique, proceed with user registration
        await FirebaseFirestore.instance.collection('users').doc(email).set({
          'email': email,
          'username': username,
          'password': hashedPassword,// Store hashed password in Firestore
          'phoneNumber':phoneNumber,
          'address':address,
        });

        // Clear all input fields after successful registration
        _emailController.clear();
        _usernameController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
        _phoneNumberController.clear();

        // Registration successful, navigate to login page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LogIn()),
        );
        Fluttertoast.showToast(
          msg: "Sign Up Successful!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );


      } catch (e) {
        // Handle registration errors
        print('Error registering user: $e');
      }
    }
  }

  void _login() {

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LogIn()),
    );

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(26.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'SIGN UP',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: _validateEmail,
                        ),
                        SizedBox(height: 8.0),
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: _validateUsername,
                        ),
                        SizedBox(height: 8.0),
                        TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            labelText: 'Address',
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: _validateAddress,
                        ),
                        SizedBox(height: 8.0),
                        TextFormField(
                          controller: _phoneNumberController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: _validatePhoneNumber,
                        ),
                        SizedBox(height: 8.0),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          obscureText: true,
                          validator: _validatePassword,
                        ),
                        SizedBox(height: 8.0),
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          obscureText: true,
                          validator: _validateConfirmPassword,
                        ),
                        SizedBox(height: 20.0,)
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: _register,
                child: Text('Register', style: TextStyle(color: Colors.black),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: _login,
                child: Text(
                  'Already have an account? Login',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );

                },
                child: Text(
                  'Skip for Now',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
