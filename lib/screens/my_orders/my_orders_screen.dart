import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'orders_detail.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({Key? key}) : super(key: key);

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _uid = "";
  String _name = 'Bethelhem Misgina';

  void _getData() async {
    User? user = _auth.currentUser;
    _uid = user!.uid;

    final DocumentSnapshot userDocs = await FirebaseFirestore.instance
        .collection("customers")
        .doc(_uid)
        .get();
    setState(() {
      _name = userDocs.get("name");
    });
    print(_uid);
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            const SliverAppBar(
              expandedHeight: 50,
              floating: false,
              pinned: true,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  "My Orders",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                centerTitle: true,
              ),
              centerTitle: true,
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const TabBar(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 0,
                      ),
                      isScrollable: true,
                      labelColor: Colors.green,
                      labelStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      unselectedLabelColor: Colors.grey,
                      unselectedLabelStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                      tabs: [
                        Tab(
                          text: "Processing",
                        ),
                        Tab(
                          text: "Canceled",
                        ),
                        Tab(
                          text: "Delivered",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 600,
                      child: TabBarView(
                        children: [
                          ordersCard(
                            "processing orders",
                            Colors.orange,
                          ),
                          ordersCard(
                            "canceled orders",
                            Colors.deepPurple,
                          ),
                          ordersCard(
                            "delivered orders",
                            Colors.teal.shade800,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> ordersCard(
      String collection, Color statusColor) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection(collection).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<DocumentSnapshot<Map<String, dynamic>>> documents =
                snapshot.data!.docs;
            return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                
                  return ((documents[index]['customer information']["userId"]
                                  .toString())
                              .compareTo(_uid) ==
                          0)
                      ? Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: "OrderId: ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            TextSpan(
                                              text: documents[index]['orderId']
                                                  ,
                                              style: const TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: Colors.grey,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      documents[index]['orderData'],
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: "Total amount: ",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                            ),
                                          ),
                                          TextSpan(
                                            text: documents[index]
                                                    ["TotalPricewithDelivery"]
                                                .toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    MaterialButton(
                                      color: Colors.green.shade300,
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    OrdersDetail(
                                                      document: documents[index]
                                                          ['orderId'],
                                                      collection: collection,
                                                    ))));
                                      },
                                      child: const Text(
                                        "Details",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    collection == "processing orders"
                                        ? MaterialButton(
                                            onPressed: () {
                                              cancleOrder(
                                                  orderId: documents[index]
                                                      ['orderId']);
                                            },
                                            color: Colors.red.shade500,
                                            child: const Text(
                                              "Cancel",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : const Text(""),
                                    collection == "canceled orders"
                                        ? MaterialButton(
                                            onPressed: () {
                                              reOrder(
                                                  orderId: documents[index]
                                                      ['orderId']);
                                            },
                                            color: Colors.orange.shade500,
                                            child: const Text(
                                              "Reorder",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : const Text(""),
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        documents[index]['status'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: statusColor,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      :  Container();
                  // }
                  // return Container();
                });
          } else if (!snapshot.hasData) {
            return const Center(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return const Center(
              child: Center(
                child: Text("No Data Found"),
              ),
            );
          }
        });
  }
}

void cancleOrder({required orderId}) async {
  var doc = await FirebaseFirestore.instance
      .collection("processing orders")
      .doc(orderId)
      .get();

  try {
    await FirebaseFirestore.instance
        .collection('canceled orders')
        .doc(orderId)
        .set({
      "customer information": {
        'userId': doc["customer information"]["userId"],
        'name': doc["customer information"]["name"],
        'email': doc["customer information"]["email"],
        'phoneNumber': doc["customer information"]["phoneNomber"],
      },
      "delivery information": {
        'city': doc["delivery information"]["city"],
        'subCity': doc["delivery information"]["subCity"],
        'street': doc["delivery information"]["street"],
      },
      "ordered products": doc["ordered products"],
      "TotalPricewithDelivery": doc["TotalPricewithDelivery"],
      "deliveryFee": doc["deliveryFee"],
      "subtotal": doc["subtotal"],
      "orderData": doc["orderData"],
      "orderId": doc["orderId"],
      'name': doc["name"],
      'status': "canceled"
    });
    await FirebaseFirestore.instance
        .collection("processing orders")
        .doc(orderId)
        .delete();
    print("deleted");
  } catch (e) {
    print(e);
  }
}

void reOrder({required orderId}) async {
  var doc = await FirebaseFirestore.instance
      .collection("canceled orders")
      .doc(orderId)
      .get();

  try {
    await FirebaseFirestore.instance
        .collection('processing orders')
        .doc(orderId)
        .set({
      "customer information": {
        'userId': doc["customer information"]["userId"],
        'name': doc["customer information"]["name"],
        'email': doc["customer information"]["email"],
        'phoneNumber': doc["customer information"]["phoneNomber"],
      },
      "delivery information": {
        'city': doc["delivery information"]["city"],
        'subCity': doc["delivery information"]["subCity"],
        'street': doc["delivery information"]["street"],
      },
      "ordered products": doc["ordered products"],
      "TotalPricewithDelivery": doc["TotalPricewithDelivery"],
      "deliveryFee": doc["deliveryFee"],
      "subtotal": doc["subtotal"],
      "orderData": doc["orderData"],
      "orderId": doc["orderId"],
      'name': doc["name"],
      'status': "processing"
    });
    await FirebaseFirestore.instance
        .collection("canceled orders")
        .doc(orderId)
        .delete();
    print("deleted");
  } catch (e) {
    print(e);
  }
}
