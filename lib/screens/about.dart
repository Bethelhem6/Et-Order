// ignore_for_file: no_leading_underscores_for_local_identifiers, avoid_print

import 'package:email_launcher/email_launcher.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Uri urlFacebook = Uri.parse('https://www.facebook.com/etherbal');
    Uri urlInstagram = Uri.parse('https://www.instagram.com/etherbal_official');

    Uri contact = Uri.parse('+251965585858');
    Email _email = Email(
        to: ['mathiosm@yahoo.com'], cc: [''], bcc: [''], subject: '', body: '');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "About",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        // width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Image(
              image: AssetImage(
                "assets/head.jpg",
              ),
              height: 50,
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 400,
              width: 360,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      "At Etherbal we blend nature and science for beauty and healthy life style.",
                      style: TextStyle(fontSize: 20, color: Colors.black54),
                    ),
                  ),
                  const SizedBox(
                    height: 0,
                  ),
                  ListTile(
                    onTap: () async {
                      await EmailLauncher.launch(_email);
                    },
                    leading: const Icon(
                      Icons.mail,
                      color: Colors.green,
                    ),
                    title: const Text(
                      "Email",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: const Text("mathiosm@yahoo.com"),
                  ),
                  Divider(
                    height: 5,
                    color: Colors.grey[700],
                  ),
                  ListTile(
                    onTap: () async {
                      var number = Uri.parse('tel:$contact');
                      if (await canLaunchUrl(number)) {
                        launchUrl(number);
                      } else {
                        print("error");
                      }
                    },
                    leading: const Icon(
                      Icons.phone,
                      color: Colors.green,
                    ),
                    title: const Text(
                      "Contact Us",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: const Text("096 558 5858"),
                  ),
                  Divider(
                    height: 5,
                    color: Colors.grey[700],
                  ),
                  ListTile(
                    onTap: () async {
                      if (await canLaunchUrl(urlFacebook)) {
                        launchUrl(urlFacebook);
                      } else {
                        print("error");
                      }
                    },
                    leading: const Icon(
                      Icons.facebook,
                      color: Colors.green,
                    ),
                    title: const Text(
                      "Facebook",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: const Text("https://www.facebook.com/etherbal/"),
                  ),
                  Divider(
                    height: 5,
                    color: Colors.grey[700],
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (await canLaunchUrl(urlInstagram)) {
                        launchUrl(urlInstagram);
                      } else {
                        print("error");
                      }
                    },
                    child: ListTile(
                      leading: const Icon(
                        Icons.language,
                        color: Colors.green,
                      ),
                      title: const Text(
                        "Instagram",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Text(urlInstagram.toString()),
                    ),
                  ),
                  Divider(
                    height: 5,
                    color: Colors.grey[700],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
