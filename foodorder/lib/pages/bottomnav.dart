import 'package:flutter/material.dart';
import 'package:foodorder/pages/home.dart';
import 'package:foodorder/pages/menu.dart';
import 'package:foodorder/pages/order.dart';
import 'package:foodorder/pages/ordern.dart';
import 'package:foodorder/pages/profile.dart';
import 'package:foodorder/pages/wallet.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;

  late List<Widget> pages;
  late Widget currentPage;
  late Home homepage;
  late Profile profile;
  late Ordern order;
  late Menu menu;

  @override
  void initState() {
    homepage = Home();
    order = Ordern();
    profile = Profile();
    menu = Menu();
    pages = [homepage, menu, order, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTabIndex,
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank_outlined, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined, size: 30),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined, size: 30),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 30),
            label: 'Profile',
          ),
        ],
        backgroundColor: Colors.black,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey[700],
        selectedFontSize: 14,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedIconTheme: IconThemeData(opacity: 0.8, size: 30),
        unselectedIconTheme: IconThemeData(opacity: 0.6, size: 28),
      ),
      body: pages[currentTabIndex],
    );
  }
}
