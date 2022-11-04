import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_project/screens/pages/packages/main_categories.dart';
import 'package:demo_project/util/column.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../pages/recommended_items_detail/Each_items_detail.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  var _currentPage = 0.0;
//  final double _height = Dimensions.pageViewContainer;
  PageController pageController = PageController(viewportFraction: 0.85);

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        _currentPage = pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    // dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // slider section
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            // <2> Pass `Stream<QuerySnapshot>` to stream
            stream:
                FirebaseFirestore.instance.collection('packages').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return const Center(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return Container(
                  // color: Colors.red,
                  margin: const EdgeInsets.only(top: 20),
                  height: 300,
                  child: PageView.builder(
                      controller: pageController,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainCategory(
                                    id: snapshot.data!.docs[index]['id'],
                                  ),
                                ),
                              ),
                              child: Container(
                                  height: 200,
                                  margin:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.green[200],
                                      image: DecorationImage(
                                          image: NetworkImage(snapshot
                                              .data!.docs[index]['image']),
                                          fit: BoxFit.cover))),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 100,
                                width: 240,
                                margin: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black45,
                                          blurRadius: 5,
                                          offset: Offset(0, 5)),
                                      BoxShadow(
                                          color: Colors.white,
                                          offset: Offset(-5, 0)),
                                      BoxShadow(
                                          color: Colors.white,
                                          offset: Offset(5, 0))
                                    ]),
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 15, right: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppColumn(
                                        text: snapshot.data!.docs[index]
                                            ['title'],
                                      ),
                                      Text(
                                        " Birr ${snapshot.data!.docs[index]['price']}",
                                        style: TextStyle(
                                          color: Colors.green[200],
                                          fontSize: 20,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      // Row(
                                      //   children: [
                                      //     Icon(
                                      //       Icons.star,
                                      //       color: Colors.green[500],
                                      //       size: 18,
                                      //     ),
                                      //     Icon(
                                      //       Icons.star,
                                      //       color: Colors.green[500],
                                      //       size: 18,
                                      //     ),
                                      //     Icon(
                                      //       Icons.star,
                                      //       color: Colors.green[500],
                                      //       size: 18,
                                      //     ),
                                      //     Icon(
                                      //       Icons.star,
                                      //       color: Colors.green[500],
                                      //       size: 18,
                                      //     ),
                                      //     Icon(
                                      //       Icons.star_border,
                                      //       color: Colors.green[500],
                                      //       size: 18,
                                      //     ),
                                      //   ],
                                      // )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }));
            }),

        // Dots below the packages
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            // <2> Pass `Stream<QuerySnapshot>` to stream
            stream:
                FirebaseFirestore.instance.collection('packages').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return const Center(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return DotsIndicator(
                dotsCount: snapshot.data!.docs.length,
                position: _currentPage,
                decorator: DotsDecorator(
                  activeColor: Colors.green,
                  size: const Size.square(9.0),
                  activeSize: const Size(18.0, 9.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
              );
            }),

        const SizedBox(
          height: 15,
        ),
        //recomended Text
        Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(
              left: 30,
            ),
            child: const Text(
              "Single Products",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )),

        const SizedBox(
          width: 50,
        ),
// Rcommended Lists
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          // <2> Pass `Stream<QuerySnapshot>` to stream
          stream: FirebaseFirestore.instance.collection('products').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: ((context, index) {
                    return Container(
                      // height: ,
                      margin: const EdgeInsets.only(
                          left: 20, bottom: 10, right: 20),
                      child: Row(
                        children: [
                          ///image section
                          GestureDetector(
                            onTap: (() => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EachItemDetail(
                                    id: snapshot.data!.docs[index]['id'],
                                    press: () {},
                                  ),
                                ))),
                            child: Container(
                              height: 100,
                              width: 120,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.green[200],
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        snapshot.data!.docs[index]['image']),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          ),
                          // text section
                          Expanded(
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EachItemDetail(
                                      id: snapshot.data!.docs[index]['id'],
                                      press: () {},
                                    ),
                                  )),
                              child: Container(
                                height: 100,
                                //  / width: 200,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20)),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, top: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        snapshot.data!.docs[index]['title'],
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      //pice
                                      Text(
                                        "Birr ${snapshot.data!.docs[index]['price']}",
                                        style: TextStyle(
                                            color: Colors.grey[900],
                                            fontWeight: FontWeight.w200,
                                            fontSize: 17),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }));
            }
            return Container();
          },
        )
      ],
    );
  }
}
