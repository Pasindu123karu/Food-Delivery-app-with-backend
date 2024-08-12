import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodorder/pages/bottomnav.dart';
import 'package:foodorder/pages/login.dart';
import 'package:foodorder/service/database.dart';
import 'package:foodorder/service/shared_pref.dart';
import 'package:foodorder/widget/widget_support.dart';
import 'package:random_string/random_string.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void registration() async {
    if (_formKey.currentState!.validate()) {
      String email = mailController.text.trim();
      String password = passwordController.text.trim();
      String name = nameController.text.trim();
      String address = addressController.text.trim();
      String phoneNumber = phoneNumberController.text.trim();

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        String Id = randomAlphaNumeric(10);
        Map<String, dynamic> addUserInfo = {
          "Name": name,
          "Email": email,
          "Wallet": "0",
          "Id": Id,
          "Address": address,
          "PhoneNumber": phoneNumber,
        };

        await DatabaseMethods().addUserDetail(addUserInfo, Id);

        await SharedPreferenceHelper().saveUserName(name);
        await SharedPreferenceHelper().saveUserEmail(email);
        await SharedPreferenceHelper().saveUserPhoneNumber(phoneNumber);
        await SharedPreferenceHelper().saveUserAddress(address);
        await SharedPreferenceHelper().saveUserWallet('100');
        await SharedPreferenceHelper().saveUserId(Id);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orange,
            content: Text("Registered Successfully", style: TextStyle(fontSize: 20.0))));

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNav()));
      } catch (e) {
        print('Error during registration: $e');
      }
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
                  SizedBox(height: 10),
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text("Sign Up", style: AppWidget.HeadlineTextFeildStyle()),
                            TextFormField(
                              controller: nameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Name';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  hintText: 'Name',
                                  prefixIcon: Icon(Icons.person_outline)),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: mailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter E-mail';
                                }
                                // Regular expression for email validation
                                String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                                RegExp regex = RegExp(emailPattern);
                                if (!regex.hasMatch(value)) {
                                  return 'Invalid email format';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Email',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Password';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  hintText: 'Password',
                                  prefixIcon: Icon(Icons.lock_outline)),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: addressController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Address';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  hintText: 'Address',
                                  prefixIcon: Icon(Icons.home)),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: phoneNumberController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Phone Number';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  hintText: 'Phone Number',
                                  prefixIcon: Icon(Icons.phone)),
                            ),
                            SizedBox(height: 30),
                            GestureDetector(
                              onTap: registration,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Color(0Xffff5722),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                  child: Text(
                                    "SIGN UP",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => LogIn()));
                              },
                              child: Text(
                                "Already have an account? Login",
                                style: AppWidget.semiBoldTextFeildStyle(),
                              ),
                            ),
                          ],
                        ),
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
