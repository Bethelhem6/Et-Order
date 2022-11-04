// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class order_summery extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double total;

  const order_summery(
      {Key? key,
      required this.subtotal,
      required this.total,
      required this.deliveryFee})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
      margin: const EdgeInsets.only(top: 5),
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
                "$subtotal",
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
                "$deliveryFee",
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.all(15),
            color: Colors.green,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Text("$total",
                    // ignore: unnecessary_const
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
