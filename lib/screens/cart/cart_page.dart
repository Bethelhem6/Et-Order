// ignore_for_file: deprecated_member_use, camel_case_types, no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:demo_project/provider/cart_and%20_provider.dart';
import 'package:demo_project/screens/delivery_information/checkout.dart';
import 'package:demo_project/screens/home/home_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../delivery_information/delivery_info_page.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Cart();
  }
}

class _Cart extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

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
                    cartProvider.clearCart();
                    Navigator.pop(context);
                  },
                  child: const Text("Yes"),
                ),
              ],
            );
          });
    }

    return cartProvider.cartList.isEmpty
        ? Scaffold(
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage("assets/welcome.jpg"),
                  ),
                  Container(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "Cart is Empty !",
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      )),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 55),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
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
                          "Shop Now",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                "Your Cart (${cartProvider.cartList.length})",
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ListView.builder(
                        // scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: cartProvider.cartList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: double.infinity,
                            height: 110,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            // padding:
                            //     const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  //
                                  children: [
                                    Image(
                                      image: NetworkImage(cartProvider
                                          .cartList.values
                                          .toList()[index]
                                          .image),
                                      width: 100,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cartProvider.cartList.values
                                              .toList()[index]
                                              .id,
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        // SizedBox(
                                        //   height: 3,
                                        // ),
                                        Text(
                                            ("Price: ${cartProvider.cartList.values.toList()[index].price * cartProvider.cartList.values.toList()[index].quantity}")
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 15)),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.remove_circle,
                                                color: Colors.green,
                                              ),
                                              onPressed: cartProvider
                                                          .cartList.values
                                                          .toList()[index]
                                                          .quantity ==
                                                      1
                                                  ? () {}
                                                  : () {
                                                      cartProvider
                                                          .decremenFromCart(
                                                              cartProvider
                                                                  .cartList
                                                                  .values
                                                                  .toList()[
                                                                      index]
                                                                  .title,
                                                              cartProvider
                                                                  .cartList
                                                                  .values
                                                                  .toList()[
                                                                      index]
                                                                  .id,
                                                              cartProvider
                                                                  .cartList
                                                                  .values
                                                                  .toList()[
                                                                      index]
                                                                  .image,
                                                              cartProvider
                                                                  .cartList
                                                                  .values
                                                                  .toList()[
                                                                      index]
                                                                  .price);
                                                    },
                                            ),
                                            Text(
                                                "${cartProvider.cartList.values.toList()[index].quantity}"),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.add_circle,
                                                color: Colors.green,
                                              ),
                                              onPressed: () {
                                                cartProvider.addToCart(
                                                    cartProvider.cartList.values
                                                        .toList()[index]
                                                        .title,
                                                    cartProvider.cartList.values
                                                        .toList()[index]
                                                        .id,
                                                    cartProvider.cartList.values
                                                        .toList()[index]
                                                        .image,
                                                    cartProvider.cartList.values
                                                        .toList()[index]
                                                        .price);
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    cartProvider.removeItem(cartProvider
                                        .cartList.values
                                        .toList()[index]
                                        .id);
                                  },
                                ),
                              ],
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: bottom_section(cartProvider: cartProvider),
          );
  }
}

class bottom_section extends StatelessWidget {
  const bottom_section({
    Key? key,
    required this.cartProvider,
  }) : super(key: key);

  final CartProvider cartProvider;

  @override
  Widget build(BuildContext context) {
    var _uuid = const Uuid();
    final cartProvider = Provider.of<CartProvider>(context);

    return Container(
      width: double.infinity,
      height: 150,
      margin: const EdgeInsets.only(top: 5, bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Subtotal",
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                "Birr ${cartProvider.subTotal}",
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Delivery Fee",
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                "Birr ${cartProvider.deliveryFee}",
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: TextStyle(
                    color: Colors.green[300],
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "${cartProvider.deliveryFee + cartProvider.subTotal}",
                style: TextStyle(
                    color: Colors.green[300],
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                shape: const RoundedRectangleBorder(),
                primary: Theme.of(context).accentColor),
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Checkout(
                          subtotal: cartProvider.subTotal,
                          deliveryFee: cartProvider.deliveryFee,
                          total: cartProvider.deliveryFee +
                              cartProvider.subTotal)));
            },
            child: const Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10),
              child: Text(
                "Check Out",
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
