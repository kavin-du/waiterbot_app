import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:waiterbot_app/providers/fetch_shop_items.dart';
import 'package:waiterbot_app/providers/final_orders_provider.dart';
import 'package:waiterbot_app/providers/foodlist_provider.dart';
import 'package:waiterbot_app/screens/enter_shopId.dart';
import 'package:waiterbot_app/screens/qrscan.dart';
import 'package:waiterbot_app/screens/sign_screen.dart';
import 'package:waiterbot_app/screens/success_screen.dart';
import './screens/otp.dart';
import './screens/image_slides.dart';
import './screens/qrscan.dart';
import 'providers/auth_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/sign_state_provider.dart';
import 'screens/error_screen.dart';
import 'screens/food_list.dart';
import 'screens/notifications.dart';

///
// ? register -> OTP -> imageslider -> qr scan -> food list
// ! login -> qr scan -> food list
/// 
// TODO: when launched: qr scan

void main() {
  // debugPaintSizeEnabled = true;
  runApp(MultiProvider(
    providers: [
        ChangeNotifierProvider(create: (context) => SignStateProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),  
        ChangeNotifierProvider(create: (context) => FoodListProvider()),
        ChangeNotifierProvider(create: (context) => FinalOrdersProvider()), // add only to the relevant parent
        ChangeNotifierProvider(create: (context) => FetchShopItems()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),

      ],
      child: MaterialApp(
      home: SignScreen(),
      // home: ErrorScreen("hello error"),
      // * home: OTP(),
      // * home: ImageSlides(),  
      // * home: QRScan(), 
      // * home: EnterShopId(),   
      // home: FoodList(),
      routes: {
        '/enterShopId': (context) => EnterShopId(),
        '/imageSlides': (context) => ImageSlides(),
        '/signScreen': (context) => SignScreen(),
        '/foodList': (context) => FoodList(),
        '/qrScan': (context) => QRScan(),
        '/notifications': (context) => Notifications(),
      },
      debugShowCheckedModeBanner: false,
    ),
  ));
}