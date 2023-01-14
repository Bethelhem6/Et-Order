import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_project/screens/product_review/review.dart';
import 'package:demo_project/screens/product_review/review_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../../provider/cart_and _provider.dart';
import '../../../util/column.dart';
import '../../../util/expandable.dart';
import '../../../util/icons.dart';
import '../../provider/whishlist_provider.dart';
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
  // late var box;

  // void openHiveBox() async {
  //   box = await Hive.openBox('wishlist_list');

  // }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final whishlistProvider = Provider.of<WhishlistProvider>(context);

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
                  child: CircularProgressIndicator(),
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AppColumn(
                          text: productDoc['title'],
                        ),
                        Row(
                          children: [
                            RatingBar.builder(
                              initialRating: 4.2,
                              minRating: 4,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 1.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              ignoreGestures: true,
                              onRatingUpdate: (rating) {},
                              updateOnDrag: true,
                              itemSize: 22,
                            ),
                            Text(
                              "(4.2)",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => ProductReview(
                                          productId: widget.id,
                                          productTitle: productDoc['title'],
                                        ))));
                          },
                          child: Text(
                            "View Reviews",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[600]),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Divider(
                          height: 2,
                          color: Colors.green[100],
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
                    child: Center(
                      child: CircularProgressIndicator(),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
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
                              (cartProvider.cartList
                                      .containsKey(productDoc['title']))
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
                            onTap: () async {
                              whishlistProvider.addOrRemoveWish(
                                  productDoc['id'],
                                  productDoc['title'],
                                  productDoc['image'],
                                  double.parse(productDoc['price']));
                              //   Whishlist wishlist = Whishlist(
                              //       image: productDoc['image'],
                              //       title: productDoc['title'],
                              //       price:  double.parse(productDoc['price']),
                              //       id: productDoc['id']);
                              //   var box = await Hive.openBox('wishlist_list');
                              //       box.put(productDoc['id'], wishlist);
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
                      ],
                    ));
              }),
    );
  }
}
