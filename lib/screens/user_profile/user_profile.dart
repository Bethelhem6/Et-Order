// ignore_for_file: use_build_context_synchronously, prefer_final_fields, unused_element

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_project/screens/about.dart';
import 'package:demo_project/screens/change_pasword_page.dart';
import 'package:demo_project/wishlist/wishlist_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/cart_and _provider.dart';
import '../cart/cart_page.dart';
import '../login/login_page.dart';

class UserScreen extends StatefulWidget {
  static const routeName = '/User-screen';

  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  double top = 0;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _uid = '';
  String _name = '';
  String _email = '';
  String _joinedAt = '';
  int _phoneNumber = 0;
  String _userImageUrl = '';

  late ScrollController _scrollController;

  void _getData() async {
    User? user = _auth.currentUser;
    _uid = user!.uid;

    final DocumentSnapshot userDocs =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();

    _name = userDocs.get('name');
    _email = userDocs.get('email');
    _joinedAt = userDocs.get('joinedDate');
    _phoneNumber = userDocs.get('phoneNumber');
    _userImageUrl = userDocs.get("imageUrl");
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {});
    });
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                pinned: true,
                stretch: true,
                expandedHeight: 250,
                flexibleSpace: LayoutBuilder(builder: (ctx, cons) {
                  top = cons.biggest.height;
                  return FlexibleSpaceBar(
                    centerTitle: true,
                    background: _userImageUrl == ""
                        ? null
                        : Image.network(
                            _userImageUrl,
                            fit: BoxFit.cover,
                          ),
                    title: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: top <= 200 ? 1.0 : 0.0,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 12,
                          ),
                          CircleAvatar(
                            backgroundImage: _userImageUrl == ""
                                ? null
                                : NetworkImage(
                                    _userImageUrl,
                                  ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(_name.toString())
                        ],
                      ),
                    ),
                  );
                }),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListView(
                    primary: false,
                    shrinkWrap: true,
                    children: [
                      // User Bag
                      const _userTileText(text: 'User Bag'),
                      const _userTileHeightSpace(height: 10),

                      Consumer<CartProvider>(builder: (context, cp, _) {
                        return Card(
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Cart()));
                            },
                            leading: Badge(
                              toAnimate: true,
                              animationType: BadgeAnimationType.slide,
                              position: BadgePosition.topEnd(top: -4, end: -10),
                              badgeContent: Text(
                                cp.cartList.length.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                              child: const Icon(
                                Icons.shopping_cart,
                                size: 30,
                                color: Colors.green,
                              ),
                            ),
                            title: const Text('Cart'),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        );
                      }),
                      Card(
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const WhishlistPage()));
                            },
                           
                              leading: const Icon(
                                Icons.favorite,
                                size: 30,
                                color: Colors.red,
                              ),
                            
                            title: const Text('Whishlist'),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      

                      // User Settings
                      const _userTileHeightSpace(height: 15),
                      const _userTileText(text: 'User Settings'),
                      const _userTileHeightSpace(height: 10),

                      _userListTile(
                        lIcon: Icons.power_settings_new,
                        color: Colors.red,
                        title: 'Logout',
                        onTap: () async {
                          await _auth.signOut();
                          Navigator.pop(context);
                          // Navigator.pop(context);

                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const Login()));
                          // print("loggedout");
                        },
                      ),

                      _userListTile(
                        lIcon: Icons.edit,
                        color: Colors.purple,
                        title: 'Change Password',
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const ChangePassword())));
                        },
                      ),

                      // User Information
                      const _userTileHeightSpace(height: 15),
                      const _userTileText(text: 'User Informattion'),
                      const _userTileHeightSpace(height: 10),
                      _userListTile(
                        lIcon: Icons.call,
                        color: Colors.green.shade700,
                        title: 'Phone Number',
                        subTitle: _phoneNumber.toString(),
                        onTap: () {},
                      ),
                      _userListTile(
                        lIcon: Icons.email,
                        color: Colors.yellow.shade700,
                        title: 'Email',
                        subTitle: _email,
                        onTap: () {},
                      ),

                      _userListTile(
                        lIcon: Icons.watch_later,
                        color: Colors.redAccent.shade100,
                        title: 'Join Date',
                        subTitle: _joinedAt,
                      ),
                      const _userTileText(text: 'About Company'),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const About()),
                          );
                        },
                        child: ListTile(
                          leading: const Icon(Icons.help_outline_rounded),
                          iconColor: Colors.green,
                          title: const Text('About'),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // _buildFab(),
        ],
      ),
    );
  }
}

// ignore: camel_case_types
class _userListTile extends StatelessWidget {
  final IconData lIcon;
  final Color color;
  final String title;
  final String? subTitle;
  final IconData? tIcon;
  final VoidCallback? tIconCallBack;
  final VoidCallback? onTap;
  const _userListTile({
    this.subTitle,
    this.tIcon,
    this.tIconCallBack,
    this.onTap,
    Key? key,
    required this.lIcon,
    required this.color,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          lIcon,
          color: color,
        ),
        title: Text(title),
        subtitle: subTitle == null ? null : Text(subTitle!),
        onTap: onTap,
        trailing: IconButton(
          icon: Icon(tIcon),
          onPressed: tIconCallBack,
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class _userTileHeightSpace extends StatelessWidget {
  final double height;
  const _userTileHeightSpace({
    Key? key,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

// ignore: camel_case_types
class _userTileText extends StatelessWidget {
  final String text;
  const _userTileText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      ' $text',
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        // decoration: TextDecoration.underline,
      ),
    );
  }
}
