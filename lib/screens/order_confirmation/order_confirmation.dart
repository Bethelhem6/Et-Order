// ignore_for_file: unused_field, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'components/order_summery.dart';

class OrderConfirmation extends StatefulWidget {
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String orderId;

  const OrderConfirmation({
    Key? key,
    required this.subtotal,
    required this.total,
    required this.deliveryFee,
    required this.orderId,
  }) : super(key: key);
  @override
  State<OrderConfirmation> createState() => _OrderConfirmationState();
}

class _OrderConfirmationState extends State<OrderConfirmation> {
  String _name = '';
  String _uid = '';

  void _getName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      _uid = user!.uid;

      final DocumentSnapshot userDocs = await FirebaseFirestore.instance
          .collection("processing orders")
          .doc(widget.orderId)
          .get();
      setState(() {
        _name = userDocs.get('name');
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _getName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios)),
        title: const Text(
          "Order Confirmation",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            color: Colors.grey[300],
            child: Row(children: [
              Container(
                margin: const EdgeInsets.only(left: 20, top: 40),
                child: const Image(
                  image: AssetImage(
                    "assets/success.png",
                  ),
                  height: 60,
                ),
              ),
              Container(
                // color: Colors.green[50],
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(top: 40),
                child: const Text(
                  "Your Order is Complete!",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ]),
          ),
          Container(
            // color: Colors.green[50],
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 10, left: 10),
            child: Text(
              "Hello $_name,\n\nThank you for purchasing on BJ Etherbal.",
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, top: 20, bottom: 5),
            // margin: const EdgeInsets.all(10),
            child: const Text(
              "Order Summery",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(
            height: 3,
            color: Colors.grey,
          ),
          const SizedBox(
            height: 10,
          ),
          order_summery(
              subtotal: widget.subtotal,
              deliveryFee: widget.deliveryFee,
              total: widget.total),
          // Container(
          //   padding: const EdgeInsets.only(left: 20, top: 20, bottom: 5),
          //   // margin: const EdgeInsets.all(10),
          //   child: const Text(
          //     "Order Details",
          //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          //   ),
          // ),
          const Divider(
            height: 3,
            color: Colors.grey,
          ),
          const SizedBox(
            height: 30,
          ),
          MaterialButton(
            child: const Text(
              "Back to home",
              style: TextStyle(
                color: Colors.green,
                fontSize: 18,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          // const order_detail(),
        ]),
      ),
    );
  }
}
