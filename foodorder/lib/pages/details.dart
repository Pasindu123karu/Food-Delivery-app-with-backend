import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodorder/service/database.dart';
import 'package:foodorder/service/shared_pref.dart';
import 'package:foodorder/widget/widget_support.dart';

class Details extends StatefulWidget {
  String image, name, detail, price;
  Details(
      {required this.detail,
        required this.image,
        required this.name,
        required this.price});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int a = 1, total = 0;
  String? id;

  getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ontheload();
    total = int.parse(widget.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
        margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 20.0),
            decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
            BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
            ),
            ],
            ),
            child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0), // Adjust the top padding to move the icon down
                      child: const Icon(
                        Icons.arrow_back_ios_new_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                ],
              ),
            const SizedBox(height: 20.0),
            ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.network(
            widget.image,
            width: MediaQuery.of(context).size.width - 40.0,
            height: MediaQuery.of(context).size.height / 2.5,
            fit: BoxFit.fill,
            ),
            ),
            const SizedBox(height: 15.0),
            Row(
            children: [
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
            widget.name,
            style: AppWidget.semiBoldTextFeildStyle(),
            ),
            ],
            ),
            Spacer(),
            GestureDetector(
            onTap: () {
            if (a > 1) {
            --a;
            total = total - int.parse(widget.price);
            }
            setState(() {});
            },
            child: Container(
            decoration: BoxDecoration(
            color: Colors.deepOrange,
            borderRadius: BorderRadius.circular(8)),
            child: Icon(
            Icons.remove,
            color: Colors.white,
            ),
            ),
            ),
            SizedBox(width: 20.0),
            Text(
            a.toString(),
            style: AppWidget.semiBoldTextFeildStyle(),
            ),
            SizedBox(width: 20.0),
            GestureDetector(
            onTap: () {
            ++a;
            total = total + int.parse(widget.price);
            setState(() {});
            },
            child: Container(
            decoration: BoxDecoration(
            color: Colors.deepOrange,
            borderRadius: BorderRadius.circular(8)),
            child: Icon(
            Icons.add,
            color: Colors.white,
            ),
            ),
            )
            ],
            ),
            SizedBox(height: 20.0),
            Text(
            widget.detail,
            maxLines: 4,
            style: AppWidget.LightTextFeildStyle(),
            ),
            SizedBox(height: 30.0),
            Row(
            children: [
            Text(
            "Delivery Time",
            style: AppWidget.semiBoldTextFeildStyle(),
            ),
            SizedBox(width: 25.0),
            Icon(
            Icons.alarm,
            color: Colors.black54,
            ),
            SizedBox(width: 5.0),
            Text(
            "30 min",
            style: AppWidget.semiBoldTextFeildStyle(),
            )
            ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0 ,left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Price",
                        style: AppWidget.semiBoldTextFeildStyle(),
                      ),
                      Text(
                        "\$" + total.toString(),
                        style: AppWidget.HeadlineTextFeildStyle(),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      Map<String, dynamic> addFoodtoCart = {
                        "Name": widget.name,
                        "Quantity": a.toString(),
                        "Total": total.toString(),
                        "Image": widget.image
                      };
                      await DatabaseMethods().addFoodToCart(addFoodtoCart, id!);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.orange,
                          content: Text(
                            "Food Added to Cart",
                            style: TextStyle(fontSize: 18.0),
                          )));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Add to cart",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'Poppins'),
                          ),
                          SizedBox(
                            width: 30.0,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(8)),
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),)
    );
  }
}
