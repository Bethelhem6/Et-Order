// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_project/screens/delivery_information/delivery_info_page.dart';
import 'package:demo_project/services/nofification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../../provider/cart_and _provider.dart';
import '../order_confirmation/components/order_detail.dart';
import '../order_confirmation/order_confirmation.dart';

class Checkout extends StatefulWidget {
  final double subtotal;
  final double deliveryFee;
  final double total;
  const Checkout(
      {Key? key,
      required this.subtotal,
      required this.total,
      required this.deliveryFee})
      : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';

  String _city = '';
  String _subCity = '';
  String _street = '';
  String _fullName = '';
  late int _phoneNumber;
  bool _isLoading = false;
  final _uuid = Uuid();
  User? user = FirebaseAuth.instance.currentUser;

  // storeNotificationToken() async {
  //   final currentUser = user!.uid;
  //   String? token = await FirebaseMessaging.instance.getToken();
  //   FirebaseFirestore.instance.collection("users").doc(currentUser).set({
  //     "token": token,
  //   }, SetOptions(merge: true));
  // }

  void datas() {
    final currentUser = user!.uid;
    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        // <2> Pass `Stream<QuerySnapshot>` to stream
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            print("no address found");
          }
          if (snapshot.data == null) {
            return const Center(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          var addressDoc = snapshot.data!;
          _email = addressDoc['email'];
          _phoneNumber = addressDoc['phoneNumber'];

          _fullName = addressDoc['name'];
          _city = addressDoc['delivery information']['city'];
          _subCity = addressDoc['delivery information']['subCity'];
          _street = addressDoc['delivery information']['street'];
          return Container();
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // FirebaseMessaging.instance.getInitialMessage();
    // FirebaseMessaging.onMessage.listen((event) {
    //   LocalNotificationService.display(event);

    //   print("FCM message recieved");
    // });
    // storeNotificationToken();
    datas();
  }

  // sendNotification(String title, String token) async {
  //   final data = {
  //     'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //     'id': '1',
  //     'status': 'done',
  //     'message': title,
  //   };

  //   try {
  //     http.Response response =
  //         await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //             headers: <String, String>{
  //               'Content-Type': 'application/json',
  //               'Authorization':
  //                   'key=AAAA-Oi9gko:APA91bGc-5hXTwHBKFja3NldGer2luTzreay-HbBaLcho4j4OFxykRQXlDGK4LQNShA4gMO716MjNekJW3_EIxD62KunjHAuM-MqgORsHf7iqoZlgFdf21VIFoUwHu0m_tX0MkKJOyPP'
  //             },
  //             body: jsonEncode(<String, dynamic>{
  //               'notification': <String, dynamic>{
  //                 'title': title,
  //                 'body': 'You are followed by someone'
  //               },
  //               'priority': 'high',
  //               'data': data,
  //               'to': '$token'
  //             }));

  //     if (response.statusCode == 200) {
  //       print("Yeh notificatin is sended");
  //     } else {
  //       print("Error");
  //     }
  //   } catch (e) {}
  // }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final currentUser = user!.uid;
    var date = DateTime.now().toString();
    var parsedDate = DateTime.parse(date);
    var formattedDate =
        '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text(
            "Checkout",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(
            padding: EdgeInsets.only(top: 18.0, left: 18, bottom: 10),
            child: Text(
              "Select delivery Address",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.normal),
            ),
          ),
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              // <2> Pass `Stream<QuerySnapshot>` to stream
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) {
                  print("no address found");
                }
                if (snapshot.data == null) {
                  return const Center(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                var addressDoc = snapshot.data!;
                _email = addressDoc['email'];
                _phoneNumber = addressDoc['phoneNumber'];

                _fullName = addressDoc['name'];
                _city = addressDoc['delivery information']['city'];
                _subCity = addressDoc['delivery information']['subCity'];
                _street = addressDoc['delivery information']['street'];

                return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ListTile(
                      // isThreeLine: true,
                      title: Text(
                        "${addressDoc['delivery information']['city']}, ${addressDoc['delivery information']['subCity']}, ${addressDoc['delivery information']['street']}",
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),

                      tileColor: Colors.grey.shade100,
                      trailing: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DeliveryInformation()));
                        },
                        child: Text(
                          "Change",
                          style: TextStyle(
                              color: Colors.orange,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ));
              }),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Order Details",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.normal),
            ),
          ),
          order_detail(),
        ]),
        bottomSheet: BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "Order Summery",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    const Divider(
                      height: 3,
                      color: Colors.grey,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      color: Colors.green[50],
                      height: 200,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              const Text(
                                "SUBTOTAL: ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Birr ${widget.subtotal}",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                "DELIVERY FEE:",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Birr  ${widget.deliveryFee} ",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "TOTAL:",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Birr ${widget.total} ",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          GestureDetector(
                            onTap: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              final orderId = _uuid.v4();
                              // final _isValid = _formKey.currentState!.validate();
                              // FocusScope.of(context).unfocus();

                              // if (_isValid) {
                              //   _formKey.currentState!.save();
                              User? user = FirebaseAuth.instance.currentUser;
                              final _uid = user!.uid;
                              try {
                                await FirebaseFirestore.instance
                                    .collection('processing orders')
                                    .doc(orderId)
                                    .set({
                                  "customer information": {
                                    'userId': _uid,
                                    'name': _fullName,
                                    'email': _email,
                                    'phoneNumber': _phoneNumber,
                                  },
                                  "delivery information": {
                                    'city': _city,
                                    'subCity': _subCity,
                                    'street': _street,
                                  },
                                  "ordered products": [
                                    ...cartProvider.cartList.values
                                        .map((value) => value.toMap())
                                        .toList()
                                  ],
                                  "TotalPricewithDelivery": widget.total,
                                  "deliveryFee": widget.deliveryFee,
                                  "subtotal": widget.subtotal,
                                  "orderData": formattedDate,
                                  "orderId": orderId,
                                  'name': _fullName,
                                  'status': "Processing"
                                });
                                setState(() {
                                  _isLoading = true;
                                });
                                Navigator.pop(context);
                                // sendNotification("title", token!);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OrderConfirmation(
                                              subtotal: widget.subtotal,
                                              deliveryFee: widget.deliveryFee,
                                              total: widget.total,
                                              orderId: orderId,
                                            )));
                              } catch (e) {
                                print(e.toString());
                              }

                              cartProvider.clearCart();
                            },
                            child: Container(
                              //width: 200,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50.0, vertical: 20),
                              decoration: BoxDecoration(
                                  color: Colors.green[300],
                                  borderRadius: BorderRadius.circular(20)),
                              child: _isLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      "Order Now",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },),);
  }
}
