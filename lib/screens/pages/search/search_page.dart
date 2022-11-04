import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_project/screens/pages/packages/main_categories.dart';
import 'package:demo_project/screens/pages/recommended_items_detail/Each_items_detail.dart';
import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate<String> {
  CollectionReference ref = FirebaseFirestore.instance.collection("products");
  CollectionReference ref2 = FirebaseFirestore.instance.collection("packages");
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
    // throw UnimplementedError();
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, query);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: ref.snapshots().asBroadcastStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return StreamBuilder(
            stream: ref2.snapshots().asBroadcastStream(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot2.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if ((snapshot.data!.docs
                      .where((QueryDocumentSnapshot<Object?> element) =>
                          element['title']
                              .toString()
                              .toLowerCase()
                              .contains(query.toLowerCase()))
                      .isEmpty) &&
                  (snapshot2.data!.docs
                      .where((QueryDocumentSnapshot<Object?> element) =>
                          element['title']
                              .toString()
                              .toLowerCase()
                              .contains(query.toLowerCase()))
                      .isEmpty)) {
                return const Center(
                  child: Text("No query found!"),
                );
                // }
              }
              if (snapshot.hasData) {
                return ListView(
                  children: [
                    ...snapshot.data!.docs
                        .where((QueryDocumentSnapshot<Object?> element) =>
                            element['title']
                                .toString()
                                .toLowerCase()
                                .contains(query.toLowerCase()))
                        .map(
                      (QueryDocumentSnapshot<Object?> data) {
                        final String title = data.get('title');
                        final String image = data.get('image');
                        final String price = data.get('price');
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EachItemDetail(
                                        press: () {}, id: data.get('id'))));
                          },
                          title: Text(title),
                          leading: Image.network(image),
                          subtitle: Text(price),
                        );
                      },
                    ),
                  ],
                );
              } else if (snapshot2.hasData) {
                return ListView(
                  children: [
                    ...snapshot2.data!.docs
                        .where((QueryDocumentSnapshot<Object?> element) =>
                            element['title']
                                .toString()
                                .toLowerCase()
                                .contains(query.toLowerCase()))
                        .map(
                      (QueryDocumentSnapshot<Object?> data) {
                        final String title = data.get('title');
                        final String image = data.get('image');
                        final String price = data.get('price');
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MainCategory(id: data.get('id'))));
                          },
                          title: Text(title),
                          leading: Image.network(image),
                          subtitle: Text(price),
                        );
                      },
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: Text("No query found!"),
                );
              }
            });
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text(" search any our product here"),
    );
  }
}
