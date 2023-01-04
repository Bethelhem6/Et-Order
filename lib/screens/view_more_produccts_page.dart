import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_project/screens/packages/main_categories.dart';
import 'package:demo_project/screens/recommended_items_detail/Each_items_detail.dart';
import 'package:flutter/material.dart';

class ViewMore extends StatefulWidget {
  final String collection;

  const ViewMore({Key? key, required this.collection}) : super(key: key);

  @override
  State<ViewMore> createState() => _ViewMoreState();
}

class _ViewMoreState extends State<ViewMore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text("More Products"),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection(widget.collection)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            var data = snapshot.data!.docs;

            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 2 / 2,
                ),
                itemCount: data.length,
                itemBuilder: (ctx, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => widget.collection == "packages"
                              ? MainCategory(
                                    id: data[index]['id'],
                                  )
                              : EachItemDetail(
                                      id: data[index]['id'],
                                      press: () {},
                                    ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Stack(
                        children: [
                          Container(
                            height: 300,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.green[200],
                              image: DecorationImage(
                                  image: NetworkImage(data[index]['image']),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          Positioned(
                            bottom: -5,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 60,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data[index]['title'],
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      " Birr ${data[index]['price']}",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
