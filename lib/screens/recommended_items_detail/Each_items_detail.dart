// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers, unused_local_variable, use_build_context_synchronously, prefer_const_declarations, file_names

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_project/provider/whishlist_provider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../provider/cart_and _provider.dart';
import '../../../util/expandable.dart';
import '../../../util/icons.dart';
import '../cart/cart_page.dart';

class EachItemDetail extends StatefulWidget {
  final String id;
  final Function press;
  const EachItemDetail({Key? key, required this.press, required this.id})
      : super(key: key);

  @override
  State<EachItemDetail> createState() => _EachItemDetailState();
}

class _EachItemDetailState extends State<EachItemDetail> {
  int count = 1;
  bool isAdded = false;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final whishlistProvider = Provider.of<WhishlistProvider>(context);

    final _uuid = const Uuid();

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          // <2> Pass `Stream<QuerySnapshot>` to stream
          stream: FirebaseFirestore.instance
              .collection('products')
              .doc(widget.id)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            var productDoc = snapshot.data!;
            //  var doc = snapshot.data!.docs[widget.index];
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  toolbarHeight: 70,
                  title:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Consumer<CartProvider>(builder: (context, cp, _) {
                      return Badge(
                        toAnimate: true,
                        shape: BadgeShape.circle,
                        borderRadius: BorderRadius.circular(5),
                        position: BadgePosition.topEnd(top: -10, end: 0),
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
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const Cart()))),
                          child: const AppIcon(
                            icon: Icons.shopping_cart_outlined,
                            iconColor: Colors.green,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      );
                    }),
                  ]),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20)),
                        color: Colors.green[300],
                      ),
                      width: double.maxFinite,
                      padding: const EdgeInsets.only(top: 5, bottom: 10),
                      child: Center(
                          child: Text(
                        productDoc['title'],
                        style: const TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  pinned: true,
                  backgroundColor: Colors.white,
                  expandedHeight: 300,
                  flexibleSpace: FlexibleSpaceBar(
                    background: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Image.network(
                            productDoc['image'],
                            width: double.maxFinite,
                            fit: BoxFit.cover,
                          );
                        }),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(
                              top: 10, left: 20, right: 20),
                          child: ExpandableTextWidget(
                              text: productDoc['description'])),
                    ],
                  ),
                )
              ],
            );
          }),

//favorite icon with the add to cart button
      bottomNavigationBar: StreamBuilder<
              DocumentSnapshot<Map<String, dynamic>>>(
          // <2> Pass `Stream<QuerySnapshot>` to stream
          stream: FirebaseFirestore.instance
              .collection('products')
              .doc(widget.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            var productDoc = snapshot.data!;
            return Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                height: 120,
                padding: const EdgeInsets.only(
                    top: 30, bottom: 30, left: 20, right: 20),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                    color: Colors.grey[200]),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  GestureDetector(
                    onTap: () {
                      if (cartProvider.cartList
                          .containsKey(productDoc['title'])) {
                        return;
                      } else {
                        cartProvider.addToCart(
                          productDoc['id'],
                          productDoc['title'],
                          productDoc['image'],
                          double.parse(productDoc['price']),
                        );
                      }
                    },
                    child: Container(
                      width: 240,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(right: 20),
                      padding: const EdgeInsets.only(
                          top: 15, bottom: 15, left: 15, right: 15),
                      // ignore: sort_child_properties_last
                      child: Text(
                        (cartProvider.cartList.containsKey(productDoc['title']))
                            ? "In Cart"
                            : "Birr ${productDoc['price'] * count} | Add to cart",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.green),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        whishlistProvider.addOrRemoveWish(
                            productDoc['id'],
                            productDoc['title'],
                            productDoc['image'],
                            double.parse(productDoc['price']));
                      },
                      child: whishlistProvider.whishlist
                              .containsKey(productDoc['title'])
                          ? AppIcon(
                              icon: Icons.favorite,
                              backgroundColor: Colors.white,
                              iconColor: Colors.red.shade600,
                              iconSize: 30,
                              size: 45,
                            )
                          : AppIcon(
                              icon: Icons.favorite_outline,
                              backgroundColor: Colors.white,
                              iconColor: Colors.red.shade600,
                              iconSize: 30,
                              size: 45,
                            )),
                ]),
              ),
            ]);
          }),
    );
  }
}
