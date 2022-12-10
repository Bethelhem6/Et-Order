// ignore_for_file: unused_import

import 'dart:async';

import 'package:demo_project/auth/auth_screen.dart';
import 'package:demo_project/screens/delivery_information/address_page.dart';

import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeName = '/landing-screen';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  // late AnimationController _animationController;
  // late Animation<double> _animation;

  final List<String> _images = [
    'assets/splash.png',
  ];

  // @override
  // void initState() {
  //   // _images.shuffle();

  //   _animationController = AnimationController(
  //     vsync: this,
  //     duration: const Duration(seconds: 20),
  //   );
  //   _animation =
  //       CurvedAnimation(parent: _animationController, curve: Curves.linear)
  //         ..addListener(() {
  //           setState(() {});
  //         })
  //         ..addStatusListener((animationStatus) {
  //           if (animationStatus == AnimationStatus.completed) {
  //             _animationController.reset();
  //             _animationController.forward();
  //           }
  //         });

  //   _animationController.forward();
  //   super.initState();
  // }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = const Duration(seconds: 4);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>  const AuthStateScreen(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              _images[0],
              fit: BoxFit.cover,
              // alignment: FractionalOffset(_animation.value, 0),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              SizedBox(height: 100),
              Center(
                child: Text(
                  'Welcome to',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 35),
                ),
              ),
              Center(
                child: Text(
                  'BJ Etherbal Shop',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 45),
                ),
              ),
            ],
          ),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     Row(
          //       children: [
          //         const SizedBox(width: 10),
          //         Expanded(
          //           child: ElevatedButton(
          //             onPressed: () {
          //               Navigator.push(context,
          //                   MaterialPageRoute(builder: (context) => Login()));
          //             },
          //             child: const Text(
          //               'Login',
          //               style: TextStyle(fontSize: 25, color: Colors.white),
          //             ),
          //           ),
          //         ),
          //         const SizedBox(width: 10),
          //         Expanded(
          //           child: ElevatedButton(
          //             onPressed: () {
          //               Navigator.push(context,
          //                   MaterialPageRoute(builder: (context) => Signup()));
          //             },
          //             child: const Text(
          //               'Signup',
          //               style: TextStyle(fontSize: 25, color: Colors.white),
          //             ),
          //           ),
          //         ),
          //         const SizedBox(width: 10),
          //       ],
          //     ),
          //     const SizedBox(height: 100),
          //   ],
          // ),
        ],
      ),
    );
  }
}
