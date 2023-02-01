// ignore_for_file: use_build_context_synchronously, prefer_final_fields, unused_element, non_constant_identifier_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:demo_project/services/global_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../home/main_page.dart';
import '../login/login_page.dart';

class Signup extends StatefulWidget {
  static const routeName = '/signup';

  const Signup({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _Signup();
  }
}

class _Signup extends State<Signup> {
  var checkBoxValue = false;
  void _chanageVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  String _fullName = '';
  String _city = '';
  String _subCity = '';
  String _street = '';
  late int _phoneNumber;
  File? _image;
  String _url = '';

  FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalMethods _globalMethods = GlobalMethods();
  bool _isLoading = false;
  bool showTerms = false;

  Future _getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image!.path);
    });
  }

  bool _isVisible = false;

  void _submitData() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    var date = DateTime.now().toString();
    var parsedDate = DateTime.parse(date);
    var formattedDate =
        '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
    if (isValid) {
      if (checkBoxValue) {
        _formKey.currentState!.save();
      }
    }

    try {
      if (_image == null) {
        return _globalMethods.showDialogues(context, 'Please provide an image');
      } else {
        setState(() {
          _isLoading = true;
        });
        final ref = FirebaseStorage.instance
            .ref()
            .child('userimages')
            .child('$_fullName.jpg');
        await ref.putFile(_image!);
        _url = await ref.getDownloadURL();

        await _auth.createUserWithEmailAndPassword(
            email: _email.toLowerCase().trim(), password: _password.trim());

        final User? user = _auth.currentUser;
        final uid = user!.uid;
        FirebaseFirestore.instance.collection('customers').doc(uid).set({
          'id': uid,
          'name': _fullName,
          'email': _email,
          'phoneNumber': _phoneNumber,
          'imageUrl': _url,
          'joinedDate': formattedDate,
          'role': 'customer',
          "customer information": {
            'name': _fullName,
            'email': _email,
            'phoneNumber': _phoneNumber,
          },
          "delivery information": {
            'city': _city,
            'subCity': _subCity,
            'street': _street,
          },
          "addressAddedDate": formattedDate,

          // 'createdAt': TimeStamp.now()
        });

        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => const MainPage()),
            ));
      }
    } catch (e) {
      _globalMethods.showDialogues(context, e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _numberFocusNode = FocusNode();
  FocusNode _streetFocusNode = FocusNode();
  FocusNode _cityFocusNode = FocusNode();
  FocusNode _subcityFocusNode = FocusNode();

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
    _numberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back_ios)),
          title: const Text(
            "Sign Up",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 120.0, vertical: 10),
                      child: InkWell(
                        onTap: _getImage,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.green.shade500,
                          backgroundImage:
                              _image == null ? null : FileImage(_image!),
                          child: Icon(
                            _image == null ? Icons.camera_alt : null,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    Text(
                      "Please enter your information.",
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      TextFormField(
                        onSaved: (value) {
                          _fullName = value!;
                        },
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_numberFocusNode),
                        key: const ValueKey('name'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          // filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          prefixIcon: const Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        onSaved: (value) {
                          _phoneNumber = int.parse(value!);
                        },
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_emailFocusNode),
                        // keyboardType: TextInputType.emailAddress,
                        key: const ValueKey('number'),
                        validator: (value) {
                          if (value!.length < 10) {
                            return 'Phone number must be 11 units';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          // filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          prefixIcon: const Icon(Icons.phone),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      email(),
                      const SizedBox(
                        height: 15,
                      ),
                      password(),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        child: Text(
                          "Delivery address Information",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      delivery_information_form(),
                      terms(),
                      const SizedBox(
                        height: 15,
                      ),
                      Signup(context),
                      log_in(context),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget email() {
    return TextFormField(
      onSaved: (value) {
        _email = value!;
      },
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_passwordFocusNode),
      keyboardType: TextInputType.emailAddress,
      key: const ValueKey('email'),
      validator: (value) {
        if (value!.isEmpty || !value.contains('@')) {
          return 'Please enter a valid email address';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        // labelStyle: const TextStyle(
        // fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
        labelText: "Email",
        // hintText: "bettymisg6@gmail.com",
        hintStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Colors.grey[500]),
        // floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        prefixIcon: const Icon(Icons.email),
      ),
    );
  }

  Widget password() {
    return TextFormField(
      focusNode: _passwordFocusNode,
      onSaved: (value) {
        _password = value!;
      },
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_cityFocusNode),
      obscureText: !_isVisible,
      key: const ValueKey('password'),
      validator: (value) {
        if (value!.isEmpty || value.length < 6) {
          return 'Password must be atleast 6 units';
        }
        return null;
      },
      decoration: InputDecoration(
        labelStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Colors.grey[600]),
        labelText: "Password",
        // hintText: "6-digits",
        hintStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Colors.grey[500]),
        // floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isVisible = !_isVisible;
            });
          },
          icon: Icon(_isVisible ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }

  Widget confirm() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelStyle: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
        labelText: "Confirm Password",
        hintText: "Re-enter password",
        hintStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Colors.grey[500]),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  Widget Signup(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(100)),
            child: MaterialButton(
              onPressed: checkBoxValue ? _submitData : null,
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => ProductMainPage()));

              child: Center(
                  child: checkBoxValue
                      ? const Text("SIGN UP",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center)
                      : const Text("Agree on terms",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center)),
            ));
  }

  Widget terms() {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Checkbox(
                value: checkBoxValue,
                activeColor: Colors.green,
                onChanged: (newValue) {
                  setState(() {
                    checkBoxValue = newValue!;
                    showTerms = false;
                  });
                  // checkBoxValue = newValue;
                },
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showTerms = checkBoxValue;
                      });
                    },
                    child: Text(
                      "Agree on terms & contracts. ",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Text("data"),
        showTerms
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "1. As from now on you will be a family of bj etherbal onlineshope. ",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "2. You can order any ETHERBAL products using the app",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "3. After you order the products, We will send you a message to tell you in how many days will your product will be delivered.",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "4. if your orders did not delivered in those days please contact us. ",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                ],
              )
            : Container()
      ],
    );
  }

  Widget log_in(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "I have an account. ",
          style: TextStyle(
              fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 2,
        ),
        GestureDetector(
          child: const Text(
            " login",
            style: TextStyle(
                fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Login()));
          },
        ),
      ],
    );
  }

  Column delivery_information_form() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
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
                borderRadius: BorderRadius.circular(30),
              ),
              prefixIcon: const Icon(Icons.location_on_outlined),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
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
                borderRadius: BorderRadius.circular(30),
              ),
              prefixIcon: const Icon(Icons.location_city_rounded),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 0,
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
            onEditingComplete: checkBoxValue ? _submitData : null,
            decoration: InputDecoration(
              labelText: 'Street name',
              labelStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 18,
                  fontWeight: FontWeight.normal),
              // floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              prefixIcon: const Icon(Icons.streetview_rounded),
            ),
          ),
        ),
      ],
    );
  }
}
