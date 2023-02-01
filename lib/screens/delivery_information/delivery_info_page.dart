// ignore_for_file: use_build_context_synchronously, prefer_final_fields, unused_field, no_leading_underscores_for_local_identifiers, avoid_print, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class DeliveryInformation extends StatefulWidget {
  const DeliveryInformation({
    Key? key,
  }) : super(key: key);

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
    // ignore: prefer_const_declarations
    final _uuid = const Uuid();
    var date = DateTime.now().toString();
    var parsedDate = DateTime.parse(date);
    var formattedDate =
        '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "New Address",
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
              // const Padding(
              //   padding: EdgeInsets.all(20.0),
              //   child: Text(
              //     "Customer Information",
              //     style: TextStyle(
              //         color: Colors.black,
              //         fontSize: 20,
              //         fontWeight: FontWeight.bold),
              //   ),
              // ),
              // customer_information_form(),
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
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                  onTap: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    final addressId = _uuid.v4();
                    final _isValid = _formKey.currentState!.validate();
                    FocusScope.of(context).unfocus();

                    if (_isValid) {
                      _formKey.currentState!.save();
                      User? user = FirebaseAuth.instance.currentUser;

                      final _uid = user!.uid;

                      try {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(_uid)
                            .update({
                          "delivery information": {
                            'city': _city,
                            'subCity': _subCity,
                            'street': _street,
                          },
                          "addressAddedDate": formattedDate,
                          "orderId": addressId,
                          'name': _fullName,
                        });
                        setState(() {
                          _isLoading = true;
                        });
                        print("done");
                        Navigator.pop(context);
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>Ch))
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 70,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: Colors.white,
                            ))
                          : const Text(
                              "Add Address",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                    ),
                  )

                  //
                  )
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
