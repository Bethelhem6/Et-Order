import 'package:badges/badges.dart';


import 'package:demo_project/util/icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/cart_and _provider.dart';
import '../cart/cart_page.dart';
import '../signup/signup_page.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 20, top: 10),
              child: Consumer<CartProvider>(builder: (context, cp, _) {
                return Badge(
                  toAnimate: true,
                  shape: BadgeShape.circle,

                  // borderRadius: BorderRadius.circular(10),
                  position: BadgePosition.topEnd(top: -5, end: 0),
                  padding: const EdgeInsets.all(5),
                  badgeColor: Colors.red.shade300,
                  animationType: BadgeAnimationType.slide,
                  badgeContent: Text(
                    cp.cartList.length.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: ((context) => const Cart()))),
                    child: const AppIcon(
                      iconSize: 30,
                      icon: Icons.shopping_cart_outlined,
                      iconColor: Colors.white,
                      backgroundColor: Colors.green,
                    ),
                  ),
                );
              }),
            ),
          ],
          title: const Text(
            "My Account",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[300]),
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(top: 40),
                child: const Text(
                  "Currently Registered Accounts",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return Container(
                        width: double.infinity,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 30),
                              child: const CircleAvatar(
                                backgroundImage: AssetImage("assets/user.jpg"),
                                radius: 30,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Betty Misgina",
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500)),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: const [
                                      Text("Email:",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 16)),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text("bettymisg@gmail.com",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 16)),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // ),
                          ],
                        ),
                      );
                    }),
              ),
              const SizedBox(
                height: 90,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Signup()));
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green[600],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: const Text(
                    "Register Now",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
