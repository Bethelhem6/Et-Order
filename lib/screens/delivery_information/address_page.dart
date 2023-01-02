// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:demo_project/screens/delivery_information/delivery_info_page.dart';
import 'package:flutter/material.dart';

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
  int selectedAddress = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Select Address",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      bottomSheet: BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Container(
            height: 70,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             const DeliveryInformation()));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          "Continue",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const DeliveryInformation()));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "New Address",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                ]),
          );
        },
      ),
      body: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 15,
              ),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAddress = index;
                  });
                },
                child: Card(
                  shape: (selectedAddress == index)
                      ? const RoundedRectangleBorder(
                          side: BorderSide(color: Colors.green, width: 3),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        )
                      : null,
                  elevation: 10,
                  color: Colors.grey.shade200,
                  shadowColor: Colors.green.shade100,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        child: Text(
                          "Address ${index + 1}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      const AddresRowMaker(
                          text1: "Name:  ", text2: "Bethelhem Misgina"),
                      const AddresRowMaker(
                          text1: "Email:  ", text2: "bettymisg@gmail.com"),
                      const AddresRowMaker(
                          text1: "phoneNumber:  ", text2: "0918732261"),
                      const AddresRowMaker(
                          text1: "City: ", text2: " Addiss Ababa"),
                      const AddresRowMaker(
                          text1: "SubCity: ", text2: " Gulelle"),
                      const AddresRowMaker(
                          text1: "Street: ", text2: " Addisu gebeya"),
                      const SizedBox(
                        height: 18,
                      ),
                    ],
                  ),
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
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          Text(
            text2,
            overflow: TextOverflow.ellipsis,
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
