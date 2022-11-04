import 'package:flutter/material.dart';

class GlobalMethods {
  Future<void> showDialogues(BuildContext context, String subtitle) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(" Notice"),
            content: Text(subtitle),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Okay")),
              // TextButton(
              //   onPressed: () {
              //     Navigator.pop(context);
              //   },
              //   child: Text("Yes"),
              // ),
            ],
          );
        });
  }
}
