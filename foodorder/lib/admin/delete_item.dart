import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../service/firestore.dart';

class DeleteItem extends StatefulWidget {
  const DeleteItem({Key? key}) : super(key: key);

  @override
  State<DeleteItem> createState() => _DeleteItemState();
}

class _DeleteItemState extends State<DeleteItem> {
  final TextEditingController itemNameController = TextEditingController();
  String? itemId;
  String? itemName;
  double? itemPrice;
  String? itemDescription;

  final FireStoreService _fireStoreService = FireStoreService();

  Future<void> getItemDetails(String itemName) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance
          .collection('items')
          .where('itemName', isEqualTo: itemName)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final itemData = snapshot.docs.first.data();
        setState(() {
          itemId = itemData['itemId'].toString(); // Convert int to String
          itemName = itemData['itemName'];
          itemPrice = itemData['itemPrice'];
          itemDescription = itemData['itemDescription'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Item not found"),
              backgroundColor: Colors.red,
            )
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to get item details: $e"),
            backgroundColor: Colors.red,
          )
      );
    }
  }

  void deleteItem() async {
    if (itemId != null) {
      try {
        await _fireStoreService.deleteItem(itemId!);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Item deleted successfully"),
              backgroundColor: Colors.green,
            )
        );
        itemNameController.clear();
        setState(() {
          itemId = null;
          itemName = null;
          itemPrice = null;
          itemDescription = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to delete item: $e"),
              backgroundColor: Colors.red,
            )
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please select an item first"),
            backgroundColor: Colors.orange,
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Delete Food'),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
              'Enter Item Name to delete:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: itemNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Item Name',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    itemNameController.clear();
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final String enteredItemName = itemNameController.text.trim();
                if (enteredItemName.isNotEmpty) {
                  getItemDetails(enteredItemName);
                } else {
                  Fluttertoast.showToast(
                    msg: "Please enter Item Name",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.orange,
                    textColor: Colors.white,
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              child: Text("Select Item"),
            ),
            if (itemId != null)
        Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        SizedBox(height: 20),
    Text(
    'Item ID:',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    Text('$itemId'),
    SizedBox(height: 10),
    Text(
    'Item Name:',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    Text('$itemName'),
    SizedBox(height: 10),
          Text(
            'Item Price:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text('$itemPrice'),
          SizedBox(height: 10),
          Text(
            'Item Description:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text('$itemDescription'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: deleteItem,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            ),
            child: Text("Delete Food"),
          ),
        ],
        ),
              ],
            ),
        ),
    );
  }
}