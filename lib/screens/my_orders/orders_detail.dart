import 'package:flutter/material.dart';

class OrdersDetail extends StatefulWidget {
  const OrdersDetail({Key? key}) : super(key: key);

  @override
  State<OrdersDetail> createState() => _OrdersDetailState();
}

class _OrdersDetailState extends State<OrdersDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Orders Detail'),
          centerTitle: true,
          elevation: 0,
          
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.only(bottom: 100),
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (ctx, i) {
                    return InkWell(
                      onTap: () {},
                      // Navigator.of(context).pushNamed(
                      //   ProductDetailsScreen.routeName,
                      // arguments: widget.pId,

                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.grey),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 130,
                                decoration: BoxDecoration(
                                  color: Colors.purple[200],
                                  image: const DecorationImage(
                                    image: AssetImage("assets/aloe.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Flexible(
                                          child: Text(
                                            "sections[i]['title']",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 7),
                                    Row(
                                      children: [
                                        const Text(
                                          'Subtotal : ',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Flexible(
                                          child: Text(
                                            ("3354").toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Quantity : ',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Flexible(
                                          child: Text(
                                            "sections[i]['quantity']"
                                                .toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
