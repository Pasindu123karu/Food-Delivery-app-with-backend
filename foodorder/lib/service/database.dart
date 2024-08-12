import 'package:cloud_firestore/cloud_firestore.dart';



class DatabaseMethods {

  Future<DocumentReference> addOrder(Map<String, dynamic> orderData) async {
    return FirebaseFirestore.instance.collection('orders').add(orderData);
  }

  // Fetch user cart items
  Future<Stream<QuerySnapshot>> getFoodCart(String userId) async {
    return FirebaseFirestore.instance.collection('users').doc(userId).collection('Cart').snapshots();
  }


  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(userInfoMap);
  }

  UpdateUserwallet(String id, String amount) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({"Wallet": amount});
  }


  Future<void> addFoodItem(int itemId, String categoryName, String itemName, String itemDescription, double itemPrice, String ImageUrl, bool isBestSelling) {
    // Set the document ID to itemId while adding a new document
    return FirebaseFirestore.instance.collection('items').doc(itemId.toString()).set({
      'itemId': itemId,
      'categoryName': categoryName,
      'itemName': itemName,
      'itemDescription': itemDescription,
      'itemPrice': itemPrice,
      'imageUrl': ImageUrl,

    });
  }

  Future<Stream<QuerySnapshot>> getFoodItemsByCategory(String categoryName)async {
    return  FirebaseFirestore.instance
        .collection('items')
        .where('categoryName', isEqualTo: categoryName)
        .snapshots();
  }


  Future<Stream<QuerySnapshot>> getFoodItem(String name)async {
    return await FirebaseFirestore.instance
        .collection(name)
        .snapshots();
  }


  Future<void> updateFoodItem(String itemId, Map<String, dynamic> updatedItem) async {
    await FirebaseFirestore.instance.collection("foodItems").doc(itemId).update(updatedItem);
  }

  Future addFoodToCart(Map<String, dynamic> itemData, String userId) async {
    // Ensure the itemData map contains the user ID
    itemData['userId'] = userId;

    // Add the item with the user ID to the Cart collection of the specified user
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("Cart")
        .add(itemData);
  }

  // Future<Stream<QuerySnapshot>> getFoodCart(String id)async {
  //   return await FirebaseFirestore.instance.collection("users").doc(id).collection("Cart").snapshots();
  // }
  Future<DocumentSnapshot> getUserDetails(String userId) async {
    return await FirebaseFirestore.instance.collection('users').doc(userId).get();
  }
  Future<void> clearUserCart(String userId) async {
    QuerySnapshot cartSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).collection('Cart').get();
    for (var doc in cartSnapshot.docs) {
      await doc.reference.delete();
    }}






}