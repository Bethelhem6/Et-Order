// ignore_for_file: deprecated_member_use

import 'package:demo_project/provider/whishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../provider/cart_and _provider.dart';
import '../screens/home/home_header.dart';
import '../util/icons.dart';

class WhishlistPage extends StatefulWidget {
  const WhishlistPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WhishlistPage();
  }
}

class _WhishlistPage extends State<WhishlistPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final whishlistProvider = Provider.of<WhishlistProvider>(context);
    var box = Hive.box<Whishlist>("wishlist_products");

    Future<void> showDialogues(
      BuildContext context,
    ) async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Confirm Delete"),
              content: const Text(
                  "All the items will be delete! Do you want to continue?"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("No")),
                TextButton(
                  onPressed: () {
                    whishlistProvider.clearWish();
                    Navigator.pop(context);
                  },
                  child: const Text("Yes"),
                ),
              ],
            );
          });
    }

    return ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Whishlist> box, _) {
          List<Whishlist> wishlist = box.values.toList().cast<Whishlist>();

          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Wishlists",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: IconButton(
                      onPressed: () async {
                        await showDialogues(
                          context,
                        );
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 30,
                      )),
                )
              ],
              centerTitle: true,
              elevation: 0,
            ),
            body: wishlist.isEmpty
                ? SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Image(
                          image: AssetImage("assets/empty_whish.jpg"),
                        ),
                        Container(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              "Empty Wishlist!",
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            )),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 55),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 50),
                                shape: const RoundedRectangleBorder(),
                                primary: Theme.of(context).accentColor),
                            onPressed: () {
                              // Navigator.pop(c/ontext);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeHeader(),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(top: 10.0, bottom: 10),
                              child: Text(
                                "Add Some",
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: wishlist.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 1,
                        child: ListTile(
                          onTap: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context)=>));
                          },
                          tileColor: Colors.grey[100],
                          leading: Image(
                            image: NetworkImage(wishlist[index].image),
                            width: 100,
                          ),
                          title: Text(
                            wishlist[index].id,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Birr ${wishlist[index].price.toString()}",
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (cartProvider.cartList
                                      .containsKey(wishlist[index].id)) {
                                    cartProvider.removeItem(wishlist[index].id);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      duration: const Duration(
                                        milliseconds: 700,
                                      ),
                                      backgroundColor: Colors.black26,
                                      content: Text(
                                        "${wishlist[index].id} removed form cart ",
                                      ),
                                    ));
                                  } else {
                                    cartProvider.addToCart(
                                        wishlist[index].title,
                                        wishlist[index].id,
                                        wishlist[index].image,
                                        wishlist[index].price);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      duration: const Duration(
                                        milliseconds: 700,
                                      ),
                                      backgroundColor: Colors.black26,
                                      content: Text(
                                        "${wishlist[index].id} added to cart ",
                                      ),
                                    ));
                                  }
                                },
                                child: cartProvider.cartList
                                        .containsKey(wishlist[index].id)
                                    ? const AppIcon(
                                        icon: Icons.shopping_cart,
                                        backgroundColor: Colors.white,
                                        iconColor: Colors.green,
                                        iconSize: 20,
                                        size: 35,
                                      )
                                    : const AppIcon(
                                        icon: Icons.shopping_cart_outlined,
                                        backgroundColor: Colors.white,
                                        iconColor: Colors.green,
                                        iconSize: 20,
                                        size: 35,
                                      ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              whishlistProvider
                                  .removeItem(wishlist[index].title);
                              print(wishlist[index].id);
                            },
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          );
        });
  }
}
