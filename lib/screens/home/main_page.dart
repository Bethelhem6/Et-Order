import 'package:demo_project/screens/home/home_header.dart';
import 'package:demo_project/screens/my_orders/my_orders_screen.dart';
import 'package:demo_project/wishlist/wishlist_page.dart';

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
    return [
      const HomeHeader(),
      const WhishlistPage(),
      const Cart(),
      const MyOrdersScreen(),
      const UserScreen()
    ];
  }

  // ignore: non_constant_identifier_names
  List<PersistentBottomNavBarItem> NavBarItems() {
    return [
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          title: 'home',
          activeColorPrimary: Colors.grey,
          inactiveColorPrimary: Colors.green[200]),
      PersistentBottomNavBarItem(
          icon: const Icon(
            Icons.favorite,
          ),
          title: 'Wishlist',
          activeColorPrimary: Colors.red,
          inactiveColorPrimary: Colors.green[200]),
      PersistentBottomNavBarItem(
          icon: const Icon(
            Icons.shopping_cart_outlined,
            color: Colors.orange,
          ),
          title: 'cart',
          activeColorPrimary: Colors.orange.shade50,
          inactiveColorPrimary: Colors.green[200]),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.shopping_bag_outlined),
          title: 'Order History',
          activeColorPrimary: Colors.deepPurple,
          inactiveColorPrimary: Colors.green[200]),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.person),
          title: 'User',
          activeColorPrimary: Colors.purple,
          inactiveColorPrimary: Colors.green[200]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: PersistentTabView(
        // backgroundColor: Colors.grey.shade100,
        context,
        items: NavBarItems(),
        screens: _screens(),
        confineInSafeArea: true,
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows:
            true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style15,
      ),
    );
  }
}
