import 'package:flutter/material.dart';
import 'package:foodorder/pages/onboard.dart';
import '../service/auth.dart';
import '../service/shared_pref.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? profile, name, email, phoneNumber, address;

  getthesharedpref() async {
    profile = await SharedPreferenceHelper().getUserProfile();
    name = await SharedPreferenceHelper().getUserName();
    email = await SharedPreferenceHelper().getUserEmail();
    address = await SharedPreferenceHelper().getUserAddress();
    phoneNumber = await SharedPreferenceHelper().getUserPhoneNumber();

    setState(() {});
  }

  onthisload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    onthisload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: name == null ? CircularProgressIndicator() : Container(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 45.0, left: 20.0, right: 20.0),
                  height: MediaQuery.of(context).size.height / 4.3,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.deepOrangeAccent,
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.elliptical(
                              MediaQuery.of(context).size.width, 105.0))),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 6.5),
                    child: Material(
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(60),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.asset(
                          "images/user-removebg-preview.png", // Make sure this asset is in your assets directory
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 70.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name!,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 23.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            buildInfoTile(Icons.person, "Name", name ?? "Not available"),
            SizedBox(
              height: 30.0,
            ),
            buildInfoTile(Icons.email, "Email", email ?? "Not available"),
            SizedBox(
              height: 30.0,
            ),
            buildInfoTile(Icons.location_on, "Location", address ?? "Not available"),
            SizedBox(
              height: 30.0,
            ),
            buildInfoTile(Icons.phone, "Telephone", phoneNumber ?? "Not available"),
            SizedBox(
              height: 30.0,
            ),
            buildActionButton(Icons.logout, "Logout", () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Onboard()), // Directly navigates to the Onboard widget, replacing the current route
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget buildInfoTile(IconData icon, String label, String value) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 2.0,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Icon(icon, color: Colors.deepOrangeAccent),
              SizedBox(width: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600)),
                  Text(value, style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          elevation: 2.0,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Icon(icon, color: Colors.deepOrangeAccent),
                SizedBox(width: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
