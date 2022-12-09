// ignore_for_file: unnecessary_const, prefer_final_fields, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_project/screens/my_orders/my_orders_screen.dart';
import 'package:demo_project/screens/product_review/review.dart';
import 'package:demo_project/screens/user_profile/user_profile.dart';
import 'package:demo_project/services/global_method.dart';
import 'package:demo_project/wishlist/wishlist_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../search/search_page.dart';
import 'product_page.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  GlobalMethods _globalMethods = GlobalMethods();
  String _email = "";
  String _url = "";
  String _uid = "";
  String _name = '';
  bool isLoaded = false;

  FirebaseAuth _auth = FirebaseAuth.instance;

  void _getData() async {
    User? user = _auth.currentUser;
    _uid = user!.uid;

    final DocumentSnapshot userDocs =
        await FirebaseFirestore.instance.collection("users").doc(_uid).get();
    setState(() {
      _url = userDocs.get("imageUrl");
      _email = userDocs.get("email");
      _name = userDocs.get("name");
    });
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  void dispose() {
    // dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.green),
        backgroundColor: Colors.white,
        // leading: Container(
        //     width: 70,
        //     margin: const EdgeInsets.only(left: 10),
        //     child: CircleAvatar(
        //       backgroundImage: NetworkImage(
        //         _url,
        //       ),
        //       radius: 100,
        //     )),
        title: Image.asset(
          "assets/head.jpg",
          height: 45,
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              },
              icon: Icon(
                Icons.search,
                color: Colors.green[400],
                size: 30,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: const [
          Expanded(child: SingleChildScrollView(child: ProductPage())),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              child: UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Colors.green),
                accountName: Text(
                  _name,
                  style: const TextStyle(fontSize: 18),
                ),
                accountEmail: Text(_email),
                currentAccountPictureSize: const Size.square(50),
                currentAccountPicture: Center(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      _url,
                    ),
                    radius: 100,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: const Text(' My Profile '),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const UserScreen())));
                // Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart, color: Colors.green),
              title: const Text(' My Orders '),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const MyOrdersScreen())));
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.red),
              title: const Text(' Wishlists '),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const WhishlistPage())));
                // Navigator.pop(context);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.notifications, color: Colors.deepPurple),
              title: const Text(' Notification '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.star, color: Colors.amber),
              title: const Text(' Rates and Reviews '),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const ProductReview()),
                  ),
                );
                // Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red.shade700),
              title: const Text('LogOut'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
