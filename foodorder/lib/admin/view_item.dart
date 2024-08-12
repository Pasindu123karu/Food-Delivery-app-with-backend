import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewUser extends StatefulWidget {
  const ViewUser({super.key});

  @override
  State<ViewUser> createState() => _ViewUserState();
}

class _ViewUserState extends State<ViewUser> {
  final TextEditingController _searchController = TextEditingController();
  Stream<QuerySnapshot>? _usersStream;

  @override
  void initState() {
    super.initState();
    _usersStream = FirebaseFirestore.instance.collection('users').snapshots();
  }

  void _searchUsers(String query) {
    if (query.isNotEmpty) {
      setState(() {
        _usersStream = FirebaseFirestore.instance
            .collection('users')
            .where('name', isGreaterThanOrEqualTo: query)
            .where('name', isLessThanOrEqualTo: query + '\uf8ff')
            .snapshots();
      });
    } else {
      setState(() {
        _usersStream = FirebaseFirestore.instance.collection('users').snapshots();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Details"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: 'Search User',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () => _searchController.clear(),
                          ),
                        ),
                        onChanged: _searchUsers,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return Center(child: Text("No data available"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot userDoc = snapshot.data!.docs[index];
              Map<String, dynamic> userData = userDoc.data()! as Map<String, dynamic>;

              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(userData['Name'] ?? "No Name"),
                  subtitle: Text(userData['Email'] ?? "No Email"),
                  trailing: Text("\$${userData['Wallet'] ?? '0'}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetailsScreen(userId: userDoc.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class UserDetailsScreen extends StatelessWidget {
  final String userId;

  const UserDetailsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detailed User Info"),
        backgroundColor: Colors.deepOrange,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users')
            .doc(userId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: LinearProgressIndicator(
              backgroundColor: Colors.deepOrange[100],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
            ));
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return Center(child: Text("No data available"));
          }

          Map<String, dynamic> userDetails = snapshot.data!.data()! as Map<
              String,
              dynamic>;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    child: ListTile(
                      title: Text("${userDetails['Name'] ?? 'No Name'}",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight
                              .bold)),
                      subtitle: Text("${userDetails['Email'] ?? 'No Email'}"),
                      leading: Icon(
                          Icons.person, size: 40, color: Colors.deepPurple),
                      trailing: Text("\$${userDetails['Wallet'] ?? '0'}",
                          style: TextStyle(color: Colors.green[800],
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SimpleDialog(
                            title: Text('Additional Details',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            children: <Widget>[
                              ListBody(
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Icon(Icons.location_on,
                                          color: Colors.orange),
                                      SizedBox(width: 10),
                                      Expanded(child: Text(
                                          "${userDetails['Address'] ??
                                              'No Address'}",
                                          style: TextStyle(fontSize: 16))),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(Icons.phone, color: Colors.green),
                                      SizedBox(width: 10),
                                      Expanded(child: Text(
                                          "${userDetails['PhoneNumber'] ??
                                              'No Phone Number'}",
                                          style: TextStyle(fontSize: 16))),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(Icons.mail_outline,
                                          color: Colors.blue),
                                      SizedBox(width: 10),
                                      Expanded(child: Text(
                                          "${userDetails['Email'] ??
                                              'No Email'}",
                                          style: TextStyle(fontSize: 16))),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  // You can add more details in similar style
                                ],
                              ),
                              TextButton(
                                child: Text('Close',
                                    style: TextStyle(color: Colors.red)),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text("Show More Details"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}