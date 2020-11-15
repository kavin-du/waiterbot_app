import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:waiterbot_app/screens/qrscan.dart';
import 'package:waiterbot_app/screens/sign_screen.dart';
import './screens/signup.dart';
import './screens/otp.dart';
import './screens/image_slides.dart';
import './screens/qrscan.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(new SignScreen());
  // runApp(new MaterialApp(
  //   // home: OTP(),
  //   // home: ImageSlides(),
  //   home: QRScan(),
  // ));
}