import 'package:demo_project/screens/pages/cart/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../pages/login/login_page.dart';
import '../../pages/user_profile/user_profile.dart';
import 'front_page_contents/main_page.dart';

class ProductMainPage extends StatefulWidget {
  const ProductMainPage({Key? key}) : super(key: key);

  @override
  State<ProductMainPage> createState() => _ProductMainPageState();
}

class _ProductMainPageState extends State<ProductMainPage> {
  List<Widget> _screens() {
    return [const MainPage(), Cart(), UserScreen()];
  }

  // ignore: non_constant_identifier_names
  List<PersistentBottomNavBarItem> NavBarItems() {
    return [
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          title: 'home',
          activeColorPrimary: Colors.green,
          inactiveColorPrimary: Colors.green[200]),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.shopping_cart_outlined),
          title: 'cart',
          activeColorPrimary: Colors.green,
          inactiveColorPrimary: Colors.green[200]),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.person),
          title: 'User',
          activeColorPrimary: Colors.green,
          inactiveColorPrimary: Colors.green[200]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      body: PersistentTabView(
        context,
        items: NavBarItems(),
        screens: _screens(),
        navBarStyle: NavBarStyle.style1,
      ),
      
    );
  }
}
