import 'package:demo_project/setting/components/change_password.dart';
import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  static const routeName = "/setting";

  @override
  State<Setting> createState() => SettingState();
}

class SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(30),
              child: const Text(
                "Preferences",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.image_outlined),
              title: const Text("Change Profile"),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.notifications),
              title: const Text("Notifications"),
            ),
            // ListTile(
            //   onTap: () {},
            //   leading: const Icon(Icons.font_download_outlined),
            //   title: const Text("Font Size(Medium)"),
            // ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => ChangePassword())));
              },
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text("Change Password"),
            ),
          ],
        ),
      ),
    );
  }
}
