import 'package:flutter/material.dart';

class AppColumn extends StatelessWidget {
  final String text;
  const AppColumn({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          text,
          style: TextStyle(
              color: Colors.green[700],
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
