import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:waiterbot_app/providers/foodlist_provider.dart';
import 'package:waiterbot_app/screens/qrscan.dart';
import 'package:waiterbot_app/screens/sign_screen.dart';
import 'package:waiterbot_app/screens/success_screen.dart';
import 'discarded/signup.dart';
import './screens/otp.dart';
import './screens/image_slides.dart';
import './screens/qrscan.dart';
import 'providers/auth_provider.dart';
import 'providers/sign_state_provider.dart';
import 'screens/food_list.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // runApp(new SignScreen());
  runApp(MultiProvider(
    providers: [
        ChangeNotifierProvider(create: (context) => SignStateProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),  
        ChangeNotifierProvider(create: (context) => FoodListProvider()),
      ],
      child: MaterialApp(
      // home: OTP(),
      // home: ImageSlides(),      
      // home: SignScreen(),
      home: FoodList(),
      routes: {
        '/success': (context) => SuccessScreen(result: 'this is by qrcode',),
      },
    ),
  ));
}