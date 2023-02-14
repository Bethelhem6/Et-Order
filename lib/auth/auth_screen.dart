import 'package:demo_project/screens/home/main_page.dart';
import 'package:demo_project/screens/login/login_page.dart';
import 'package:demo_project/screens/welcome_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthStateScreen extends StatelessWidget {
  const AuthStateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return const MainPage();
          } else {
            return const Login();
          }
        } else if (snapshot.hasError) {
          return const Text('Error Occured');
        }
        return const WelcomeScreen();
      },
    );
  }
}
