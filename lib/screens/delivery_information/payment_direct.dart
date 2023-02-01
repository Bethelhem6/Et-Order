// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../chapa_payment/chapa_payment initializer.dart';
import '../../provider/cart_and _provider.dart';

class IntermidatePage extends StatelessWidget {
  final double total;
  const IntermidatePage({
    Key? key,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    final currentUser = user!.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Payment",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          const Center(
            child: Image(
              image: AssetImage(
                "assets/payment.jpg",
              ),
              height: 200,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('customers')
                  .doc(currentUser)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) {
                  print("no address found");
                }
                if (snapshot.data == null) {
                  return const Center(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                var addressDoc = snapshot.data!;

                String _fullName = addressDoc["customer information"]['name'];
                List name = _fullName.split(" ");
                String fname = name[0];
                String lname = name[1];
                return MaterialButton(
                  onPressed: () {
                    Chapa.paymentParameters(
                      context: context, // context
                      publicKey:
                          'CHASECK_TEST-XcLb5JUwnXY4dBPzDJJyyFFiPMSvZ7CR',
                      currency: 'ETB',
                      amount: total.toString(),
                      email: addressDoc["customer information"]['email'],
                      firstName: fname,
                      lastName: lname,
                      txRef: '34TXTHHgb',
                      title: 'title',
                      desc: 'desc',
                      namedRouteFallBack:
                          '/fallbackSuccess', // fall back route name
                    );
                  },
                  color: Colors.green[500],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Text(
                          "Go to payment",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 40,
                        )
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
