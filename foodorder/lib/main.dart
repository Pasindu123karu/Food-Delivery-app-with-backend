import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:foodorder/admin/AdminLogin.dart';
import 'package:foodorder/admin/add_food.dart';
import 'package:foodorder/admin/home_admin.dart';
import 'package:foodorder/pages/bottomnav.dart';
import 'package:foodorder/pages/home.dart';
import 'package:foodorder/pages/login.dart';
import 'package:foodorder/pages/onboard.dart';
import 'package:foodorder/pages/signup.dart';
import 'package:foodorder/pages/wallet.dart';
import 'package:foodorder/widget/app_constant.dart';
import 'package:flutter_stripe_web/flutter_stripe_web.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // Stripe.publishableKey=publishableKey;
  await Firebase.initializeApp(
  options:FirebaseOptions(
    apiKey: "AIzaSyCjas2uDoR9FwgTZORAOdjCs7hMuYcp5kM",
    appId: "1:623307548702:android:d1fb1fb6c13a561c03e60f",
    messagingSenderId: "623307548702",
    projectId: "foodorder-423ae",
  ),
  );


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Onboard(),
      debugShowCheckedModeBanner: false, // This line removes the debug logo
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
