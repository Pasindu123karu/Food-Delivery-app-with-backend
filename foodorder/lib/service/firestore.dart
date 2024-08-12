import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  Future<void> updateItem(int itemId, String categoryName, String itemName, String itemDescription, double itemPrice, String imageUrl) {
    return FirebaseFirestore.instance.collection('items').doc(itemId.toString()).update({
      'itemId': itemId,
      'categoryName': categoryName,
      'itemName': itemName,
      'itemDescription': itemDescription,
      'itemPrice': itemPrice,
      'imageUrl': imageUrl,
    });
  }
  Future<void> deleteItem(String itemId) { // Change the parameter type to String
    return FirebaseFirestore.instance.collection('items').doc(itemId).delete();
  }
}
