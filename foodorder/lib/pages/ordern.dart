import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../service/shared_pref.dart';
import '../widget/widget_support.dart';

class Ordern extends StatefulWidget {
  const Ordern({super.key});

  @override
  State<Ordern> createState() => _OrdernState();
}

class _OrdernState extends State<Ordern> {
  Stream<QuerySnapshot>? orderStream;
  String? id; // Default user name

  @override
  void initState() {
    super.initState();
    getthesharedpref().then((_) {
      if (id != null) {
        orderStream = FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: id)
            .snapshots();
      }
      setState(() {});
    });
  }

  Future<void> getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    // Ensure id is never null when used, provide a default or handle the null case.
    if (id == null) {
      // Handle the case when id is null by showing an error or setting a default id
      print('User ID is null, setting default or handling error.');
      id = 'defaultUserId'; // example of setting a default ID
    }
  }

  void showOrderDetails(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) {
        List<dynamic> items = data['items'] as List<dynamic>? ?? [];
        List<Widget> itemList = items.map((item) {
          if (item != null && item is Map<String, dynamic>) {
            String itemName = item['name'] ?? 'Unknown item';
            int itemQuantity = int.tryParse(item['quantity'].toString()) ?? 0;
            double itemPrice = 0.0;
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
                    Expanded(child: Text(data['state'] ?? 'Pending', style: TextStyle(fontSize: 16))),
                  ],
                ),
                SizedBox(height: 10),
                ...itemList,
              ],
            ),
          ),
          actions: <Widget>[
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
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return ListView(
            padding: const EdgeInsets.all(8.0),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>? ?? {};
              data['orderId'] = document.id;
              return Card(
                color: Colors.white,
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
                                style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              TextSpan(
                                text: '${data['orderId']}',
                                style: AppWidget.semiBoldTextFeildStyle1(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Status: ${data['state'] ?? 'Pending'}', style: TextStyle(color: Colors.black87, fontSize: 16)),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.shopping_cart, color: Colors.green),
                            Text('\$${data['totalPrice']}', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        } else {
          return const Center(child: Text('No orders found', style: TextStyle(color: Colors.grey)));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: buildOrderList(),
      ),
    );
  }
}
