// ignore_for_file: camel_case_types

import 'package:demo_project/provider/cart_and%20_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class order_detail extends StatefulWidget {
  const order_detail({
    Key? key,
  }) : super(key: key);

  @override
  State<order_detail> createState() => _order_detailState();
}

class _order_detailState extends State<order_detail> {
  @override
  Widget build(BuildContext context) {
    bool isLoaded = false;
    final cartProvider = Provider.of<CartProvider>(context);
    return ListView.builder(
        shrinkWrap: true,
        itemCount: cartProvider.cartList.length,
        itemBuilder: (context, index) {
          return Container(
            width: double.infinity,
            height: 60,
            margin: const EdgeInsets.only(top: 5),
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image(
                  image: NetworkImage(
                      cartProvider.cartList.values.toList()[index].image),
                  width: 100,
                ),

                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartProvider.cartList.values.toList()[index].id,
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Text("Quantity:",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16)),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                            " ${cartProvider.cartList.values.toList()[index].quantity}",
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 16)),
                        const SizedBox(
                          width: 50,
                        ),
                        Text(
                          "Birr ${cartProvider.cartList.values.toList()[index].price}",
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),

                // ),
              ],
            ),
          );
        });
  }
}
