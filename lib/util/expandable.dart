import 'package:flutter/material.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String text;
  const ExpandableTextWidget({Key? key, required this.text}) : super(key: key);

  @override
  State<ExpandableTextWidget> createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  late String firtHalf;
  late String secondHalf;
  bool hiddenText = true;
  double textHeight = 300;
  @override
  void initState() {
    super.initState();
    if (widget.text.length > textHeight) {
      firtHalf = widget.text.substring(0, textHeight.toInt());
      secondHalf =
          widget.text.substring(textHeight.toInt() + 1, widget.text.length);
    } else {
      firtHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty
          ? Text(
              firtHalf,
              style: const TextStyle(fontSize: 17, letterSpacing: 0),
            )
          : Container(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                children: [
                  Text(hiddenText
                      ? ("$firtHalf...")
                      : (firtHalf + secondHalf)),
                  InkWell(
                    onTap: () {
                      setState(() {
                        hiddenText = !hiddenText;
                      });
                    },
                    child: Row(
                      children: [
                        const Text(
                          "Show more",
                          style: TextStyle(color: Colors.blue),
                        ),
                        Icon(
                          hiddenText
                              ? (Icons.arrow_drop_down)
                              : (Icons.arrow_drop_up),
                          color: Colors.pink,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
