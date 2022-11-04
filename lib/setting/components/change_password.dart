import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios)),
        title: const Text(
          "Change Password",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        child: Container(
          margin: EdgeInsets.all(30),
          height: MediaQuery.of(context).size.height * 0.40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 10,
              ),
              password(),
              const SizedBox(
                height: 10,
              ),
              newPassword(),
              const SizedBox(
                height: 10,
              ),
              confirm(),
              const SizedBox(
                height: 10,
              ),
              changePassword(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget password() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
          labelStyle: const TextStyle(
              fontSize: 25, fontWeight: FontWeight.normal, color: Colors.black),
          labelText: "Password",
          hintText: "Enter old password",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          )),
    );
  }

  Widget newPassword() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
          labelStyle: const TextStyle(
              fontSize: 25, fontWeight: FontWeight.normal, color: Colors.black),
          labelText: "New password",
          hintText: "Enter new password",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          )),
    );
  }

  Widget confirm() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
          labelStyle: const TextStyle(
              fontSize: 25, fontWeight: FontWeight.normal, color: Colors.black),
          labelText: "Confirm password",
          hintText: "Re-enter new password",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          )),
    );
  }

  Widget changePassword(BuildContext _context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        decoration: BoxDecoration(
            color: Colors.green, borderRadius: BorderRadius.circular(100)),
        child: MaterialButton(
          onPressed: () {
            // Navigator.pushNamed(context, '/cart');
          },
          child: const Center(
            child: Text(" Change ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center),
          ),
        ));
  }
}
