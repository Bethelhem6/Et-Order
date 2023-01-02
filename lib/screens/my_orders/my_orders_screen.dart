import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'orders_detail.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({Key? key}) : super(key: key);

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.delete,
                  ),
                ),
              ],
              expandedHeight: 50,
              floating: false,
              pinned: true,
              elevation: 0,
              flexibleSpace: const FlexibleSpaceBar(
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
                          text: "Completed",
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
                            "completed orders",
                            Colors.deepPurple,
                          ),
                          ordersCard(
                            "processing orders",
                            Colors.green,
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

          return ListView(
            children: documents
                .map((doc) => Card(
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          text: doc['orderId'],
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
                                  doc['orderData'],
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        text: doc["TotalPricewithDelivery"]
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MaterialButton(
                                  color: Colors.green.shade300,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) => OrdersDetail(
                                                  document: doc['orderId'],
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
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    doc['status'],
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
                    ))
                .toList(),
          );
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
      },
    );
  }
}
