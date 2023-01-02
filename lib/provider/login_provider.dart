import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_project/services/global_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/home/home_header.dart';

class LoginProvider with ChangeNotifier {
 
  FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalMethods _globalMethods = GlobalMethods();

  void login({required BuildContext context, required String email, required String password, required String uid}) async {
    try {
      final newUser = await _auth.signInWithEmailAndPassword(
          email: email.toLowerCase().trim(),
          password: password.toLowerCase().trim());
      if (newUser != null) {
        User? user = _auth.currentUser;
        uid = user!.uid;
        final DocumentSnapshot result = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();

        String role = result.get('role');
        if (role == 'customer') {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeHeader()),
          );
        }
      }
      // print("logged in");
    } catch (e) {
      _globalMethods.showDialogues(context, e.toString());
    }
  }
}
