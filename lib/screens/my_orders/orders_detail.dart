import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdersDetail extends StatefulWidget {
  String document;
  String collection;

  OrdersDetail({Key? key, required this.document, required this.collection})
      : super(key: key);

  @override
  State<OrdersDetail> createState() => _OrdersDetailState();
}

class _OrdersDetailState extends State<OrdersDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Orders Detail'),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection(widget.collection)
                      .doc(widget.document)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data!;
                      var section = data['ordered products'];

                      return Container(
                        height: MediaQuery.of(context).size.height,
                        padding: const EdgeInsets.only(bottom: 100),
                        child: ListView.builder(
                          itemCount: section.length,
                          itemBuilder: (ctx, i) {
                            return InkWell(
                              onTap: () {},
                              // Navigator.of(context).pushNamed(
                              //   ProductDetailsScreen.routeName,
                              // arguments: widget.pId,

                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Container(
                                  width: double.infinity,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: Colors.grey),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 130,
                                        decoration: BoxDecoration(
                                          color: Colors.purple[200],
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                section[i]['image']),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    section[i]['title'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 7),
                                            Row(
                                              children: [
                                                const Text(
                                                  'Subtotal : ',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    section[i]['price'].toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  'Quantity : ',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    section[i]['quantity']
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ],
          ),
        ));
  }
}
