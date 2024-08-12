import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageOrders extends StatefulWidget {
  const ManageOrders({super.key});

  @override
  State<ManageOrders> createState() => _ManageOrdersState();
}

class _ManageOrdersState extends State<ManageOrders> {
  Stream<QuerySnapshot>? orderStream;

  @override
  void initState() {
    super.initState();
    orderStream = FirebaseFirestore.instance.collection('orders').snapshots();
  }

  void showOrderDetails(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) {
        // Extract items list, handling potential non-list or null data gracefully
        List<dynamic> items = data['items'] is List ? data['items'] : [];
        List<Widget> itemList = items.map((item) {
          // Ensure each item is a non-null Map before processing
          if (item != null && item is Map<String, dynamic>) {
            String itemName = item['name'] ?? 'Unknown item';
            int itemQuantity = int.tryParse(item['quantity'].toString()) ?? 0;
            double itemPrice = 0.0;
            // Extract and parse item total price, handling formatting and potential parse errors
            if (item['total'] != null) {
              String priceStr = item['total'].toString().replaceAll(RegExp(r'[^\d\.]'), '');
              itemPrice = double.tryParse(priceStr) ?? 0.0;
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                children: <Widget>[
                  Expanded(child: Text(itemName, style: TextStyle(fontSize: 16))),
                  Text(' x$itemQuantity ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(' \$${itemPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          }
          return Container(); // Return an empty container for any null or incorrect item data
        }).toList();

        return AlertDialog(
          title: Text('Order Details', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Row(
                  children: [
                    Icon(Icons.confirmation_number, color: Colors.orange),
                    SizedBox(width: 10),
                    Expanded(child: Text(data['orderId'] ?? 'Unknown Order ID', style: TextStyle(fontSize: 16))),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.attach_money, color: Colors.green),
                    SizedBox(width: 10),
                    Expanded(child: Text('\$${data['totalPrice']?.toStringAsFixed(2) ?? '0.00'}', style: TextStyle(fontSize: 16))),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue),
                    SizedBox(width: 10),
                    Expanded(child: Text(data['state'] ?? 'Unknown', style: TextStyle(fontSize: 16))),
                  ],
                ),
                SizedBox(height: 10),
                ...itemList,
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Approve'),
              onPressed: () {
                FirebaseFirestore.instance.collection('orders').doc(data['orderId']).update({'state': 'approved'});
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Order approved successfully'),
                      backgroundColor: Colors.green, // Green background color for success
                    )
                );
              },
            ),
            TextButton(
              child: Text('Decline'),
              onPressed: () {
                FirebaseFirestore.instance.collection('orders').doc(data['orderId']).update({'state': 'not approved'});
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Order declined successfully'),
                      backgroundColor: Colors.green, // Green background color for success
                    ));
              },
            ),
            TextButton(
              child: Text('Close', style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Widget buildOrderList() {
    return StreamBuilder<QuerySnapshot>(
      stream: orderStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          padding: const EdgeInsets.all(8.0),
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            data['orderId'] = document.id;  // Include the order ID in the data map
            return Card(
              color: Colors.greenAccent[700], // Sets the card's background color to a light green
              elevation: 8,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: InkWell(
                onTap: () => showOrderDetails(data),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Order Id: ',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            TextSpan(
                              text: '${data['orderId']}',
                              style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Status: ${data['state'] ?? 'Pending'}', style: TextStyle(color: Colors.white70, fontSize: 16)),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.shopping_cart, color: Colors.white),
                          Text('\$${data['totalPrice']}', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 20)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: buildOrderList(),
      ),
    );
  }
}
