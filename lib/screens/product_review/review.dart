// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_project/services/global_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';

import 'package:demo_project/screens/product_review/review_widget.dart';
import 'package:demo_project/util/icons.dart';

class ProductReview extends StatefulWidget {
  String productId;
  String productTitle;
  ProductReview({
    Key? key,
    required this.productId,
    required this.productTitle,
  }) : super(key: key);

  @override
  State<ProductReview> createState() => _ProductReviewState();
}

TextEditingController textarea = TextEditingController();

class _ProductReviewState extends State<ProductReview> {
  String _url = "";
  String _uid = "";
  String _name = '';
  bool isLoaded = false;
  double star = 0;
  double initialStar = 2.5;
  final _formKey = GlobalKey<FormState>();
  GlobalMethods _globalMethods = GlobalMethods();

  String id = DateTime.now().toString();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  List selected = [false, false, false, false, false];

  File? _image;

  // Future _getImage() async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  //     setState(() {
  //       _image = File(image!.path);
  //       print(_image);
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  void _getData() async {
    User? user = _auth.currentUser;
    _uid = user!.uid;

    final DocumentSnapshot userDocs =
        await FirebaseFirestore.instance.collection("users").doc(_uid).get();
    setState(() {
      _url = userDocs.get("imageUrl");
      _name = userDocs.get("name");
    });
    print(_name);
  }

  void sendReview(double star, String review, File? image, var date) async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection("reviews ${widget.productTitle}")
          .doc(id)
          .set({
        "name": _name,
        "stars": star,
        "image": _url,
        "reviewDate": date,
        "review": review,
        "picAdded": image,
      });
    } else {
      _globalMethods.showDialogues(context, "Fill all neccessary forms");
    }
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "⭐Rating & Reviews⭐",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ReviewsWidget(
          productTitle: widget.productTitle,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await bottomSheet(context);
          },
          elevation: 2,
          label: Row(
            children: const [
              Icon(
                Icons.edit,
                color: Colors.amber,
              ),
              SizedBox(
                width: 5,
              ),
              Text("Write a review")
            ],
          )),
    );
  }

  bottomSheet(BuildContext context) async {
    // var reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    var date = DateTime.now().toString();
    var parsedDate = DateTime.parse(date);
    var formattedDate =
        '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';

    showModalBottomSheet<dynamic>(
        elevation: 5,
        backgroundColor: Colors.green.shade50,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "What is your rate?",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    RatingBar.builder(
                      initialRating: initialStar,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          star = rating;
                        });
                      },
                      updateOnDrag: true,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 15.0, left: 20, right: 20),
                      // ignore: unnecessary_const
                      child: const Text(
                        "Please share your opinion",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      // ignore: unnecessary_const
                      child: const Text(
                        "about our products.",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 35),
                      child: TextFormField(
                        controller: textarea,
                        keyboardType: TextInputType.multiline,
                        maxLines: 7,
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Your review",
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                const BorderSide(color: Colors.green, width: 0),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  const BorderSide(color: Colors.green)),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 10),
                          child: Container(
                            decoration: const BoxDecoration(),
                            child: _image == null
                                ? null
                                : Image.file(
                                    _image!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: GestureDetector(
                            onTap: () async {
                              try {
                                final image = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                setState(() {
                                  _image = File(image!.path);
                                  print(_image);
                                });
                              } catch (e) {
                                print(e);
                              }
                            },
                            child: Column(
                              children: const [
                                AppIcon(
                                  icon: Icons.camera_enhance,
                                  backgroundColor: Colors.green,
                                  iconColor: Colors.white,
                                  iconSize: 30,
                                  size: 60,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Add photos",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        sendReview(star, textarea.text,
                            _image == null ? null : _image!, formattedDate);

                        textarea.clear();

                        _image = null;

                        Navigator.pop(context);
                        showBox(context);

                        print("done");
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "SEND REVIEW",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<dynamic> showBox(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                "Thank you!", // ignore: unnecessary_const
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              content: const Image(
                image: AssetImage(
                  "assets/star.png",
                ),
                height: 70,
                width: 70,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Okay.", // ignore: unnecessary_const
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ));
  }
}
