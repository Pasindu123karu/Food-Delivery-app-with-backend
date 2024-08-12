import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodorder/pages/details.dart';
import 'package:foodorder/pages/order.dart';
import 'package:foodorder/widget/widget_support.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../service/shared_pref.dart';


class DatabaseMethods {
  Stream<QuerySnapshot> getFoodItemsByCategory(String categoryName) {
    return FirebaseFirestore.instance
        .collection('items')
        .where('categoryName', isEqualTo: categoryName)
        .snapshots();
  }

  Stream<QuerySnapshot> searchFoodItems(String query) {
    return FirebaseFirestore.instance
        .collection('items')
        .where('itemName', isGreaterThanOrEqualTo: query)
        .where('itemName', isLessThanOrEqualTo: query + '\uf8ff')
        .snapshots();
  }
}

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool MainCourse = false, icecream = false, pizza = false, salad = false, burger = false;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  String currentCategory = "MainCourse"; // Default category
  String? profile, name, email; // Default user name

  @override
  void initState() {
    super.initState();

    // Call a function as soon as the widget is initialized
    onthisload();

    // Set up a listener for the search controller
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text;
      });
    });
  }

  getthesharedpref() async {
    profile = await SharedPreferenceHelper().getUserProfile();
    name = await SharedPreferenceHelper().getUserName();
    email = await SharedPreferenceHelper().getUserEmail();
    setState(() {}); // Call setState to rebuild the widget with the updated name
  }


  void onTheLoad(String category) {
    setState(() {
      currentCategory = category; // Update the currentCategory based on the tapped icon
      // Reset all to false
      MainCourse = icecream = pizza = salad = burger = false;
      // Then set the selected one to true based on the category
      switch (category) {
        case 'MainCourse':
          MainCourse = true;
          break;
        case 'Ice-cream':
          icecream = true;
          break;
        case 'Pizza':
          pizza = true;
          break;
        case 'Salad':
          salad = true;
          break;
        case 'Burger':
          burger = true;
          break;
      }
    });
  }

  onthisload() async {
    await getthesharedpref();
  }



  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot> getSearchResults() {
    if (searchQuery.isEmpty) {
      return DatabaseMethods().getFoodItemsByCategory(currentCategory);
    } else {
      return DatabaseMethods().searchFoodItems(searchQuery);
    }
  }

  Widget allItemsVertically() {
    // Create a stream that specifically fetches items
    Stream<QuerySnapshot> searchResultsStream = getSearchResults();

    return StreamBuilder<QuerySnapshot>(
      stream: searchResultsStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        var items = snapshot.data!.docs;

        return items.isNotEmpty
            ? GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,  // Adjusted for better visual balance
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            padding: EdgeInsets.all(10),
            itemCount: items.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),  // To disable GridView's own scrolling
            itemBuilder: (context, index) {
              DocumentSnapshot ds = items[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Details(
                        detail: ds['itemDescription'],
                        name: ds['itemName'],
                        price: ds['itemPrice'].toString(),
                        image: ds['imageUrl'],
                      ),
                    ),
                  );
                },
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),  // Darker shadow for better visibility
                            spreadRadius: 2,  // Increases the size of the shadow
                            blurRadius: 8,  // Softens the shadow
                            offset: Offset(0, 4),  // Vertically lower shadow for a lifting effect
                          ),
                        ],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                              child: Hero(
                                tag: 'imageHero-${ds['itemName']}',
                                child: Image.network(
                                  ds['imageUrl'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(child: CircularProgressIndicator());
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ds['itemName'],
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "Family Combo",
                                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "\$${ds['itemPrice']}",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {
                          Map<String, dynamic> itemData = {
                            'name': ds['itemName'],
                            'price': ds['itemPrice'],
                            'imageUrl': ds['imageUrl'],
                            'description': ds['itemDescription']
                          };
                          // Insert your add-to-cart logic here
                        },
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              );
            }):Center(child: CircularProgressIndicator());
      },
    );
  }




  Widget allItems() {
    // Create a stream that specifically fetches "Main Course" items
    Stream<QuerySnapshot> mainCourseStream = DatabaseMethods().getFoodItemsByCategory("MainCourse");

    return StreamBuilder<QuerySnapshot>(
        stream: mainCourseStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          var items = snapshot.data!.docs;

          return items.isNotEmpty
              ? ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              itemCount: items.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = items[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Details(
                          detail: ds['itemDescription'],
                          name: ds['itemName'],
                          price: ds['itemPrice'].toString(),
                          image: ds['imageUrl'],
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: 200,
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                                child: Hero(
                                  tag: 'imageHero-${ds['itemName']}',
                                  child: Image.network(
                                    ds['imageUrl'],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(child: CircularProgressIndicator());
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ds['itemName'],
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "Family Combo",
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "\$${ds['itemPrice']}",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                          ),
                          child: Text(
                            "Offer",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }):Center(child: CircularProgressIndicator());
        });
  }

  Widget showItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        categoryIcon(iconPath: "images/ice-cream.png", selected: icecream, onTap: () => onTheLoad("Ice-cream"), category: 'Ice-cream'),
        categoryIcon(iconPath: "images/pizza.png", selected: pizza, onTap: () => onTheLoad("Pizza"), category: 'Pizza'),
        categoryIcon(iconPath: "images/salad.png", selected: salad, onTap: () => onTheLoad("Salad"), category: 'Salad'),
        categoryIcon(iconPath: "images/burger.png", selected: burger, onTap: () => onTheLoad("Burger"), category: 'Burger'),
      ],
    );
  }

  Widget categoryIcon({required String iconPath, required bool selected, required VoidCallback onTap, required String category}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          icecream = pizza = salad = burger = false; // Reset all to false
          switch (category) { // Then set the selected one to true
            case 'Ice-cream':
              icecream = true;
              break;
            case 'Pizza':
              pizza = true;
              break;
            case 'Salad':
              salad = true;
              break;
            case 'Burger':
              burger = true;
              break;
          }
        });
        onTap();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? Colors.deepOrange : Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
          boxShadow: selected ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(2, 2),
              blurRadius: 3,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.white,
              offset: Offset(-2, -2),
              blurRadius: 3,
              spreadRadius: 1,
            )
          ] : [
            BoxShadow(
              color: Colors.white,
              offset: Offset(-2, -2),
              blurRadius: 3,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(2, 2),
              blurRadius: 3,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Image.asset(
          iconPath,
          height: 40,
          width: 40,
          fit: BoxFit.cover,
          color: selected ? Colors.white : Colors.grey[600],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name != null ? "Hello $name," : "Hello,", // Display the dynamic username
                    style: AppWidget.HeadlineTextFeildStyle(),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Ordernew()),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 20.0),
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                "Food Menu",
                style: AppWidget.HeadlineTextFeildStyle(),
              ),
              Text(
                "Discover and Get Great Food",
                style: AppWidget.LightTextFeildStyle(),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search food...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              SizedBox(height: 10.0),
              searchQuery.isEmpty ? Container(
              ) : Container(), // Hide allItems when search query is active
              SizedBox(height: 20.0),
              Container(
                margin: EdgeInsets.only(right: 0.0), // Adjust according to new margin
                child: showItem(),
              ),
              SizedBox(height: 20.0),
              allItemsVertically(),
            ],
          ),
        ),
      ),
    );
  }}