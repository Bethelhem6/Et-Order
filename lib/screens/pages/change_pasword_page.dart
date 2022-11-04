// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:demo_project/screens/pages/login/login_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  var newPassword = "";
  final newPasswordContrller = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;
  late File image;
  late String imgUrl;
  void dispose() {
    newPasswordContrller.dispose();
    super.dispose();
  }

  changePassword() async {
    try {
      await currentUser!.updatePassword(newPassword);
      FirebaseAuth.instance.signOut();
      Navigator.pop(context);
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => Login()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.black26,
        content: Text("your password is changed successfully! "),
      ));
    } catch (error) {}
  }

  late PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // imageProfile(),
              // SizedBox(height: 10,),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.70,
                child: Center(
                  child: Container(
                    margin: EdgeInsets.all(12),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Change Password",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 25,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            child: TextFormField(
                              autofocus: false,
                              obscureText: true,
                              decoration: InputDecoration(
                                label: Text("New password"),
                                hintText: "enter new password",
                                labelStyle: TextStyle(fontSize: 18),
                                border: OutlineInputBorder(),
                                errorStyle: TextStyle(
                                    color: Colors.red, fontSize: 15.0),
                              ),
                              controller: newPasswordContrller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "please enter password";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          RaisedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  newPassword = newPasswordContrller.text;
                                });
                                changePassword();
                              }
                            },
                            color: Colors.green,
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              "Update",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  letterSpacing: 1,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
