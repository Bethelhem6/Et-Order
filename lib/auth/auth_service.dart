import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth _auth;
  AuthServices(this._auth);

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
