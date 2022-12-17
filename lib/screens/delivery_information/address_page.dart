// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final String email = '';
  final String name = '';
  final String phoneNo = '';
  final String city = '';
  final String subCity = '';
  final String street = '';
  @override
  Widget build(BuildContext context) {
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
      body: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              child: Card(
                elevation: 10,
                shadowColor: Colors.green.shade100,
                child: Column(
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 18.0),
                      child: Text(
                        "Address 1",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    AddresRowMaker(
                        text1: "Name:  ", text2: "Bethelhem Misgina"),
                    AddresRowMaker(
                        text1: "Email:  ", text2: "bettymisg@gmail.com"),
                    AddresRowMaker(
                        text1: "phoneNumber:  ", text2: "0918732261"),
                    AddresRowMaker(text1: "City: ", text2: " Addiss Ababa"),
                    AddresRowMaker(text1: "SubCity: ", text2: " Gulelle"),
                    AddresRowMaker(text1: "Street: ", text2: " Addisu gebeya"),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class AddresRowMaker extends StatelessWidget {
  const AddresRowMaker({
    Key? key,
    required this.text1,
    required this.text2,
  }) : super(key: key);
  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            text1,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            text2,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
