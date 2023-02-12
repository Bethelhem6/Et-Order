import 'package:demo_project/aboutus/dev_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AboutDevelopers extends StatelessWidget {
  const AboutDevelopers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "About Developers",
            style: TextStyle(fontSize: 25),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          children: const [
            DevCrds(
              name: "Bethelhem Misgina",
              email: "bettymisg6@gmail.com",
              phoneNo: "0918732261",
              image: "assets/betty.jpg",
              address: "Addis Ababa, Ethiopia.",
                 role:     "Software Engineer,\nSelf-thought flutter &\nVue developer.",
           
            ),
            DevCrds(
              name: "Yordanos Daniel",
              email: "yordanosdaniel2019@gmail.com",
              phoneNo: "0948674981",
              image: "assets/yordi.jpg",
              address: "Addis Ababa, Ethiopia.",
              role: "Software Engineer,\nSelf-thought flutter &\nFront-end developer.",
            ),
            DevCrds(
              name: "Yeabsira Adam",
              email: "yeabsiraadam22@gmail.com",
              phoneNo: "0977796210",
              image: "assets/yobo.jpg",
              address: "Bahirdar, Ethiopia.",
              role: "Software Engineer,\nSelf-thought flutter & \nDjango Developer.  ",
            ),
          ],
        ));
  }
}

class DevCrds extends StatelessWidget {
  const DevCrds(
      {Key? key,
      required this.image,
      required this.name,
      required this.email,
      required this.phoneNo,
      required this.address, required this.role})
      : super(key: key);
  final String image;
  final String name;
  final String email;
  final String phoneNo;
  final String address;
  final String role;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
         Image(image: AssetImage(image,),height: 150,width: 120,),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                      name,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                        color: Colors.black,
                      ),
                    ),
                     Text(role,
                      style:  TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => DetailDevs(
                                      name: name,
                                      image: image,
                                      address: address,
                                      email: email,
                                      phoneNo: phoneNo,
                                    ))));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 150,
                        ),
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            Text(
                              "More",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Colors.blue,
                              ),
                            ), SizedBox(width: 15,),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.blue,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
          ]),
    );
  }
}
