// ignore_for_file: avoid_print

import 'dart:io';

import 'package:demo_project/util/icons.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductReview extends StatefulWidget {
  const ProductReview({Key? key}) : super(key: key);

  @override
  State<ProductReview> createState() => _ProductReviewState();
}

TextEditingController textarea = TextEditingController();

class _ProductReviewState extends State<ProductReview> {
  File? _image;

  Future _getImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        _image = File(image!.path);
        print(_image);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppIcon(
          icon: Icons.arrow_back_ios,
          backgroundColor: Colors.green,
          iconColor: Colors.white,
          iconSize: 25,
          // size: ,
        ),
        title: const Text(
          "Rating & Reviews",
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
        child: const ReviewsWidget(),
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
    showModalBottomSheet<dynamic>(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) {
                        return const AppIcon(
                          icon: Icons.star_outline,
                          backgroundColor: Colors.white,
                          iconColor: Colors.grey,
                          iconSize: 40,
                        );
                      },
                    ),
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
                        vertical: 20.0, horizontal: 35),
                    child: TextField(
                      controller: textarea,
                      keyboardType: TextInputType.multiline,
                      maxLines: 10,
                      decoration: const InputDecoration(
                      
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Your review",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 17,
                        ),
                        // enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Row(
                    // scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 10),
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              border: Border.all(width: 2, color: Colors.grey),
                            ),
                            child: _image == null
                                ? Text("null")
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
                          child: const AppIcon(
                            icon: Icons.camera_enhance,
                            backgroundColor: Colors.green,
                            iconColor: Colors.white,
                            iconSize: 30,
                            size: 60,
                          ),
                        ),
                      ),
                      const Text(
                        "Add photos",
                        // ignore: unnecessary_const
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
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
                ],
              ),
            ),
          );
        });
  }
}

class ReviewsWidget extends StatelessWidget {
  const ReviewsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
                  child: Card(
                    elevation: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.only(top: 20, left: 20, bottom: 10),
                          child: Text(
                            "Helen Hiwot",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              // width: 10,
                              padding:
                                  const EdgeInsets.only(left: 20, bottom: 10),
                              child: Row(
                                children: List.generate(4, (index) {
                                  return const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  );
                                }),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Icon(
                                Icons.star_outline,
                                color: Colors.amber,
                              ),
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(
                                    bottom: 10, right: 10),
                                child: const Text(
                                  "Aug 13, 2022",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ))
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            left: 20,
                            bottom: 10,
                            right: 20,
                          ),
                          child: Text(
                            "lorem First thing came to my mind was SVG files and VectorDrawables I am used to in Android, sadly Flutter doesn’t support this kind of SVG Animation just yet, flutter_svg package gave some hope but It was of no use as it is not possible to animate this expressions with it, I had to dig deeper and then I found this CustomPainter class, It gives us kind of total control over what is shown on screen(as widget), and I was like hale luya that is what we need :)",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Positioned(
                    child: Padding(
                  padding: EdgeInsets.only(
                    left: 8.0,
                    top: 5,
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 20,
                    child: Text("H"),
                  ),
                ))
              ],
            );
          }),
    );
  }
}
