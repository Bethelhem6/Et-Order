import 'package:demo_project/screens/home/home_header.dart';

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../cart/cart_page.dart';
import '../user_profile/user_profile.dart';
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Widget> _screens() {
    return [const HomeHeader(), const Cart(), const UserScreen()];
  }


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
