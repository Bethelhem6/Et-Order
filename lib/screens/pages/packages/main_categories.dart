import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/cart_and _provider.dart';
import '../../../util/column.dart';
import '../../../util/expandable.dart';
import '../../../util/icons.dart';
import '../cart/cart_page.dart';

class MainCategory extends StatefulWidget {
  final String id;

  const MainCategory({Key? key, required this.id}) : super(key: key);

  @override
  State<MainCategory> createState() => _MainCategoryState();
}

class _MainCategoryState extends State<MainCategory> {
  int count = 1;
  bool isAdded = false;
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          // <2> Pass `Stream<QuerySnapshot>` to stream
          stream: FirebaseFirestore.instance
              .collection('packages')
              .doc(widget.id)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: Center(
                  child: const CircularProgressIndicator(),
                ),
              );
            }
            var productDoc = snapshot.data!;
            return Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.maxFinite,
                    height: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                            productDoc['image'],
                          ),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
                Positioned(
                    top: 45,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const AppIcon(
                              icon: Icons.arrow_back,
                              iconSize: 26,
                              iconColor: Colors.white,
                              backgroundColor: Colors.greenAccent,
                            )),
                        Consumer<CartProvider>(builder: (context, cp, _) {
                          return Badge(
                            toAnimate: true,
                            shape: BadgeShape.circle,
                            // borderRadius: BorderRadius.circular(5),
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
                                iconColor: Colors.white,
                                backgroundColor: Colors.green,
                              ),
                            ),
                          );
                        }),
                      ],
                    )),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  top: 220,
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppColumn(
                          text: productDoc['title'],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          "Description",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                              child: ExpandableTextWidget(
                            text: productDoc['description'],
                          )),
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          }),

      //counter and add to cart button
      bottomNavigationBar:
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              // <2> Pass `Stream<QuerySnapshot>` to stream
              stream: FirebaseFirestore.instance
                  .collection('packages')
                  .doc(widget.id)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.data == null) {
                  return const Center(
                    child: const Center(
                      child: const CircularProgressIndicator(),
                    ),
                  );
                }
                var productDoc = snapshot.data!;
                return Container(
                    height: 120,
                    padding: const EdgeInsets.only(
                        top: 30, bottom: 30, left: 20, right: 20),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40)),
                        color: Colors.grey[200]),
                    child: GestureDetector(
                      onTap: isAdded
                          ? () {}
                          : () {
                              cartProvider.addToCart(
                                productDoc['id'],
                                productDoc['title'],
                                productDoc['image'],
                                double.parse(productDoc['price']),
                              );
                              setState(() {
                                isAdded = true;
                              });
                            },
                      child: Container(
                        alignment: Alignment.center,
                        width: 200,
                        padding: const EdgeInsets.only(
                            top: 15, bottom: 10, left: 15, right: 10),
                        // ignore: sort_child_properties_last
                        child: Text(
                          isAdded
                              ? "In Cart"
                              : "Birr ${productDoc['price']}| Add to cart",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.green),
                      ),
                    ));
              }),
    );
  }
}
