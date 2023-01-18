// ignore_for_file: unused_import

import 'package:demo_project/auth/auth_screen.dart';
import 'package:demo_project/provider/cart_and%20_provider.dart';
import 'package:demo_project/provider/whishlist_provider.dart';
import 'package:demo_project/screens/delivery_information/checkout.dart';
import 'package:demo_project/screens/login/login_page.dart';
import 'package:demo_project/screens/my_orders/my_orders_screen.dart';
import 'package:demo_project/screens/signup/signup_page.dart';
import 'package:demo_project/screens/view_more_produccts_page.dart';
import 'package:demo_project/screens/welcome_screen.dart';
import 'package:demo_project/services/nofification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LocalNotificationService.initialize();
  await Hive.initFlutter();
  Hive.registerAdapter(WhishlistAdapter());
  await Hive.openBox<Whishlist>('wishlist_products');

  // await Hive.deleteFromDisk();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
        ChangeNotifierProvider(create: (ctx) => WhishlistProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
          textTheme: TextTheme(
            bodyText2: GoogleFonts.cormorantGaramond(),
            bodyText1: GoogleFonts.cormorantGaramond(),
          ),
        ),
        home: AuthStateScreen(),
        // Checkout(deliveryFee: 353, subtotal: 35, total: 343),
        //  Checkout(deliveryFee: 2, subtotal: 3, total: 45),
      ),
    );
  }
}
