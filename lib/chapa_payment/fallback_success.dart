import 'package:demo_project/screens/delivery_information/checkout.dart';
import 'package:demo_project/screens/home/main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart_and _provider.dart';
import 'chapa_payment initializer.dart';

class FallbackPage extends StatefulWidget {
  const FallbackPage({Key? key}) : super(key: key);

  @override
  State<FallbackPage> createState() => _FallbackPageState();
}

class _FallbackPageState extends State<FallbackPage> {
  var args;
  String message = "";

  @override
  void initState() {
    // get data after payment charm update your database now
    Future.delayed(Duration.zero, () {
      setState(() {
        if (ModalRoute.of(context)?.settings.arguments != null) {
          args = ModalRoute.of(context)?.settings.arguments;
          print('message after payment');
          message = args['message'];
          print(args['transactionReference']);
          print(args['paidAmount']);
        }
      });
    });

    super.initState();
    // context.read<CartProvider>().getData();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          message == "paymentSuccessful"
              ? const Image(
                  image: AssetImage(
                    "assets/payment_success.png",
                  ),
                  height: 150,
                )
              : const Image(
                  image: AssetImage(
                    "assets/failed.jpg",
                  ),
                  height: 150,
                ),
          const SizedBox(
            height: 10,
          ),
          message == "paymentSuccessful"
              ? Text(
                  message,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24),
                )
              : const Text(""),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              message != "paymentSuccessful" ? Text("") : Text(""),
              MaterialButton(
                  onPressed: message == "paymentSuccessful"
                      ? () {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Checkout(
                                        total: double.parse(args['paidAmount']),
                                        deliveryFee: cartProvider.deliveryFee,
                                        subtotal: cartProvider.subTotal,
                                      )));
                        }
                      : () {
                          Navigator.pop(context);
                        },
                  color: Colors.green,
                  child: message == "paymentSuccessful"
                      ? Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10.0),
                          child: const Text(
                            "Continue",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Try Again",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                        )),
              message != "paymentSuccessful"
                  ? MaterialButton(
                      onPressed: () {
                        cartProvider.clearCart();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainPage()));
                      },
                      color: Colors.red[400],
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Cancle",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ))
                  : Text(""),
            ],
          ),
        ],
      ),
    ));
  }
}
