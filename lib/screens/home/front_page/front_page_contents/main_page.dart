// ignore_for_file: unnecessary_const

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:demo_project/services/global_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../pages/search/search_page.dart';
import 'product_page_body.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GlobalMethods _globalMethods = GlobalMethods();
  // String _email = "";
  String _url = "";
  String _uid = "";
  // String _name = '';
  bool isLoaded = false;

  FirebaseAuth _auth = FirebaseAuth.instance;

  void _getData() async {
    User? user = _auth.currentUser;
    _uid = user!.uid;

    final DocumentSnapshot userDocs =
        await FirebaseFirestore.instance.collection("users").doc(_uid).get();
    setState(() {
      // _email = userDocs.get('email');
      // _name = userDocs.get('name');
      _url = userDocs.get("imageUrl");
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
        leading: Container(
            width: 70,
            margin: EdgeInsets.only(left: 10),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                _url,
              ),
              radius: 100,
            )),
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
      // drawer: Drawer(
      //   width: 250,
      //   backgroundColor: Colors.green[50],
      //   child: ListView(
      //     // Important: Remove any padding from the ListView.
      //     // padding: EdgeInsets.zero,
      //     children: [
      //       Container(
      //         height: 220,
      //         child: DrawerHeader(
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               CircleAvatar(
      //                 backgroundImage: NetworkImage(
      //                   _url,
      //                 ),
      //                 radius: 50,
      //               ),
      //               const SizedBox(
      //                 height: 10,
      //               ),
      //               Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text(
      //                     _name,
      //                     style: const TextStyle(
      //                       fontSize: 25,
      //                       color: Colors.black,
      //                     ),
      //                   ),
      //                   Text(
      //                     _email,
      //                     style: TextStyle(
      //                         fontSize: 18,
      //                         color: Colors.grey[600],
      //                         fontStyle: FontStyle.italic,
      //                         fontWeight: FontWeight.w500),
      //                   ),
      //                 ],
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //       const Divider(
      //         height: 3,
      //         color: Colors.green,
      //       ),
      //       InkWell(
      //         onTap: () async {
      //           await _auth.signOut();
      //         },
      //         child: ListTile(
      //           title: const Text("Log out"),
      //           leading: Icon(
      //             Icons.logout,
      //             color: Colors.green[800],
      //           ),
      //         ),
      //       ),
      //       InkWell(
      //         onTap: () {
      //           Navigator.push(context,
      //               MaterialPageRoute(builder: (context) => MyAccount()));
      //         },
      //         child: ListTile(
      //           title: const Text("My Account"),
      //           leading: Icon(
      //             Icons.person,
      //             color: Colors.green[800],
      //           ),
      //         ),
      //       ),
      //       InkWell(
      //         onTap: () {
      //           Navigator.push(
      //               context, MaterialPageRoute(builder: (context) => Cart()));
      //         },
      //         child: ListTile(
      //           title: const Text("My Cart"),
      //           leading: Icon(
      //             Icons.shopping_basket,
      //             color: Colors.green[800],
      //           ),
      //         ),
      //       ),
      //       const Divider(
      //         height: 3,
      //         color: Colors.grey,
      //       ),
      //       InkWell(
      //         onTap: () {
      //           Navigator.push(context,
      //               MaterialPageRoute(builder: (context) => Setting()));
      //         },
      //         child: ListTile(
      //           title: const Text("Settings"),
      //           leading: Icon(
      //             Icons.settings,
      //             color: Colors.green[800],
      //           ),
      //         ),
      //       ),
      //       InkWell(
      //         onTap: () {
      //           Navigator.push(
      //               context, MaterialPageRoute(builder: (context) => About()));
      //         },
      //         child: ListTile(
      //           title: const Text("About"),
      //           leading: Icon(
      //             Icons.help,
      //             color: Colors.green[800],
      //           ),
      //         ),
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}
