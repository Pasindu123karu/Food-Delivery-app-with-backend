import 'package:flutter/material.dart';
import 'package:foodorder/admin/add_food.dart';
import 'package:foodorder/admin/update_item.dart';
import 'package:foodorder/admin/delete_item.dart';
import 'package:foodorder/admin/manage_orders.dart';
import 'package:foodorder/admin/view_item.dart';
import 'package:foodorder/widget/widget_support.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({Key? key}) : super(key: key);

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            buildMenuItem(
              icon: Icons.add,
              text: "Add Food Items",
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddFood())),
            ),
            buildMenuItem(
              icon: Icons.update,
              text: "Update Food Items",
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateItem())),
            ),
            buildMenuItem(
              icon: Icons.delete,
              text: "Delete Food Items",
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DeleteItem())),
            ),
            buildMenuItem(
              icon: Icons.manage_accounts,
              text: "Manage Orders",
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ManageOrders())),
            ),
            buildMenuItem(
              icon: Icons.visibility,
              text: "View Users",
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewUser())),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({required IconData icon, required String text, required VoidCallback onTap}) {
    return Card(
      elevation: 10.0, // Increased elevation for a more pronounced shadow
      shadowColor: Colors.black, // Darker shadow color for better visibility
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.greenAccent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 40.0, color: Colors.green),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(text, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
