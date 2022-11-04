// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/cart_and _provider.dart';
import 'package:uuid/uuid.dart';

import '../order_confirmation/order_confirmation.dart';

class DeliveryInformation extends StatefulWidget {
  final double subtotal;
  final double deliveryFee;
  final double total;

  const DeliveryInformation(
      {Key? key,
      required this.subtotal,
      required this.total,
      required this.deliveryFee})
      : super(key: key);

  @override
  State<DeliveryInformation> createState() => _DeliveryInformationState();
}

class _DeliveryInformationState extends State<DeliveryInformation> {
  String _email = '';

  final _formKey = GlobalKey<FormState>();
  String _city = '';
  String _subCity = '';
  String _street = '';
  String _fullName = '';
  late int _phoneNumber;
  bool _isLoading = false;

  FocusNode _namedFocusNode = FocusNode();
  FocusNode _phoneNumberFocusNode = FocusNode();
  FocusNode _streetFocusNode = FocusNode();
  FocusNode _cityFocusNode = FocusNode();
  FocusNode _subcityFocusNode = FocusNode();

  @override
  void dispose() {
    _namedFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _streetFocusNode.dispose();
    _cityFocusNode.dispose();
    _subcityFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final _uuid = Uuid();
    var date = DateTime.now().toString();
    var parsedDate = DateTime.parse(date);
    var formattedDate =
        '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Checkout",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Customer Information",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              customer_information_form(),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Delivery Information",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              delivery_information_form(),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Order Summery",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(
                height: 3,
                color: Colors.grey,
              ),
              Container(
                  padding: const EdgeInsets.only(top: 10),
                  color: Colors.green[50],
                  height: 200,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "SUBTOTAL: ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Birr ${widget.subtotal}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            "DELIVERY FEE:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Birr  ${widget.deliveryFee} ",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            "TOTAL:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Birr ${widget.total} ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          final orderId = _uuid.v4();
                          final _isValid = _formKey.currentState!.validate();
                          FocusScope.of(context).unfocus();

                          if (_isValid) {
                            _formKey.currentState!.save();
                            User? user = FirebaseAuth.instance.currentUser;
                            final _uid = user!.uid;
                            try {
                              await FirebaseFirestore.instance
                                  .collection('orders')
                                  .doc(orderId)
                                  .set({
                                "customer information": {
                                  'userId': _uid,
                                  'name': _fullName,
                                  'email': _email,
                                  'phoneNumber': _phoneNumber,
                                },
                                "delivery information": {
                                  'city': _city,
                                  'subCity': _subCity,
                                  'street': _street,
                                },
                                "ordered products": [
                                  ...cartProvider.cartList.values
                                      .map((value) => value.toMap())
                                      .toList()
                                ],
                                "TotalPricewithDelivery": widget.total,
                                "deliveryFee": widget.deliveryFee,
                                "subtotal": widget.subtotal,
                                "orderData": formattedDate,
                                "orderId": orderId,
                                'name': _fullName,
                              });

                              Navigator.pop(context);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OrderConfirmation(
                                            subtotal: widget.subtotal,
                                            deliveryFee: widget.deliveryFee,
                                            total: widget.total,
                                            orderId: orderId,
                                          )));
                            } catch (e) {
                              print(e.toString());
                            }
                          } else {
                            print("not valid");
                          }

                          cartProvider.clearCart();
                        },
                        child: Container(
                          //width: 200,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50.0, vertical: 20),
                          decoration: BoxDecoration(
                              color: Colors.green[300],
                              borderRadius: BorderRadius.circular(20)),
                          child: const Text(
                            "Order Now",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Column customer_information_form() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextFormField(
            onSaved: (value) {
              _email = value!;
            },
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(_namedFocusNode),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value!.isEmpty || !value.contains('@')) {
                return 'Please enter a valid email address';
              }
              return null;
            },
            decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18,
                    fontWeight: FontWeight.normal),
                // floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.green))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextFormField(
            focusNode: _namedFocusNode,
            onSaved: (value) {
              _fullName = value!;
            },
            validator: (value) {
              if (value!.isEmpty || value.length < 5) {
                return 'Please enter your full name';
              }
              return null;
            },
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(_phoneNumberFocusNode),
            decoration: InputDecoration(
                labelText: 'Full Name',
                labelStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18,
                    fontWeight: FontWeight.normal),
                // floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: TextFormField(
            focusNode: _phoneNumberFocusNode,
            onSaved: (value) {
              _phoneNumber = int.parse(value!);
              ;
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your Phone Number';
              }
              if (value.length < 10) {
                return "phone number must be at least 10 chars";
              }
              return null;
            },
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(_cityFocusNode),
            decoration: InputDecoration(
                labelText: 'Phone number',
                labelStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18,
                    fontWeight: FontWeight.normal),
                // floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
        ),
      ],
    );
  }

  Column delivery_information_form() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextFormField(
            focusNode: _cityFocusNode,
            onSaved: (value) {
              _city = value!;
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter City';
              }
              return null;
            },
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(_subcityFocusNode),
            decoration: InputDecoration(
                labelText: 'City',
                labelStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18,
                    fontWeight: FontWeight.normal),
                // floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.green))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextFormField(
            focusNode: _subcityFocusNode,
            onSaved: (value) {
              _subCity = value!;
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter SubCity';
              }
              return null;
            },
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(_streetFocusNode),
            decoration: InputDecoration(
                labelText: 'Subcity',
                labelStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18,
                    fontWeight: FontWeight.normal),
                // floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: TextFormField(
            focusNode: _streetFocusNode,
            onSaved: (value) {
              _street = value!;
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter Street';
              }
              return null;
            },
            onEditingComplete: () => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
                labelText: 'Street name',
                labelStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18,
                    fontWeight: FontWeight.normal),
                // floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
        ),
      ],
    );
  }
}
