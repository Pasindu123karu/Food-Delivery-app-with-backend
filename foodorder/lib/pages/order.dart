import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../service/database.dart';
import '../service/shared_pref.dart';
import '../widget/widget_support.dart';

class Ordernew extends StatefulWidget {
  const Ordernew({super.key});

  @override
  State<Ordernew> createState() => _OrdernewState();
}

class _OrdernewState extends State<Ordernew> {
  String? id;
  int total = 0;
  Stream? foodStream;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  void loadInitialData() async {
    id = await SharedPreferenceHelper().getUserId();
    if (id != null) {
      foodStream = await DatabaseMethods().getFoodCart(id!);
    }
    setState(() {});
  }

  Widget foodCart() {
    return StreamBuilder(
      stream: foodStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          total = 0;  // Reset total
          snapshot.data.docs.forEach((doc) {
            total += int.parse(doc["Total"].toString());
          });

          // Update UI after frame is built
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() {});
          });

          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              return buildCartItem(ds);
            },
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          return Text('No items in your cart');
        }
      },
    );
  }

  Widget buildCartItem(DocumentSnapshot ds) {
    int quantity = int.parse(ds["Quantity"].toString());
    int itemTotal = int.parse(ds["Total"].toString());
    int singleItemPrice = itemTotal ~/ quantity;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              GestureDetector(
                onTap: () async {
                  if (quantity > 1) {
                    int newQuantity = quantity - 1;
                    await updateCartItemQuantity(ds, newQuantity, singleItemPrice);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(8)
                  ),
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.remove, color: Colors.white),
                ),
              ),
              SizedBox(width: 10.0),
              Text(
                quantity.toString(),
                style: AppWidget.semiBoldTextFeildStyle(),
              ),
              SizedBox(width: 10.0),
              GestureDetector(
                onTap: () async {
                  int newQuantity = quantity + 1;
                  await updateCartItemQuantity(ds, newQuantity, singleItemPrice);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(8)
                  ),
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ),
              SizedBox(width: 15.0),
              ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.network(
                    ds["Image"],
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  )
              ),
              SizedBox(width: 15.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ds["Name"], style: AppWidget.semiBoldTextFeildStyle4()),
                  Text("\$${ds["Total"]}", style: AppWidget.semiBoldTextFeildStyle()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<void> updateCartItemQuantity(DocumentSnapshot doc, int newQuantity, int pricePerItem) async {
    int newTotal = newQuantity * pricePerItem;
    await doc.reference.update({
      "Quantity": newQuantity.toString(),
      "Total": newTotal.toString()
    });

    setState(() {
      total = total - int.parse(doc["Total"].toString()) + newTotal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 2.0,
              child: Container(
                padding: EdgeInsets.only(bottom: 10.0, top: 10.0, left: 10.0, right: 10.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: const Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Food Cart",
                          style: AppWidget.HeadlineTextFeildStyle(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: foodCart(),
            ),
            Spacer(),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Price", style: AppWidget.boldTextFeildStyle()),
                  Text("\$${total.toString()}", style: AppWidget.semiBoldTextFeildStyle()),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            buildActionButtons(context)
          ],
        ),
      ),
    );
  }

  Widget buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0), // Bottom padding for the entire row
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () => checkout(),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: Text(
                  "Check Out",
                    style: AppWidget.semiBoldTextFeildStyle3()
                  ),
                ),
              ),
            ),
          GestureDetector(
            onTap: () => clearCart(),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: Text(
                  "Clear Cart",
                  style: AppWidget.semiBoldTextFeildStyle3()
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> clearCart() async {
    if (id != null) {
      final cartRef = FirebaseFirestore.instance.collection('users').doc(id).collection('Cart');
      final cartDocs = await cartRef.get();
      for (var doc in cartDocs.docs) {
        await doc.reference.delete();
      }
      setState(() => total = 0);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Cart Cleared'),
            content: Text('All items have been removed from your cart.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> checkout() async {
    if (total == 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Your cart is empty.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final orderData = {
      'userId': id,
      'totalPrice': total,
      'items': [],
    };

    // Get the items from the cart to store in the order
    final cartSnapshots = await FirebaseFirestore.instance.collection('users').doc(id).collection('Cart').get();
    List items = cartSnapshots.docs.map((doc) {
      return {
        'name': doc['Name'],
        'quantity': doc['Quantity'],
        'total': doc['Total'],
        'image': doc['Image'],
      };
    }).toList();

    orderData['items'] = items;

    // Store the order in a new collection
    await FirebaseFirestore.instance.collection('orders').add(orderData);

    // Show a success message
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Your order has been placed successfully!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );

    // Optional: Clear the cart after placing the order
    for (var doc in cartSnapshots.docs) {
      await doc.reference.delete();
    }
  }
}
