import 'dart:convert';

import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waiterbot_app/services/app_urls.dart';

import './success_screen.dart';

class QRScan extends StatefulWidget {
  @override
  _QRScanState createState() => _QRScanState();
}

class _QRScanState extends State<QRScan> {
  String cameraScanResult = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan the QR Code'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  primary: Colors.white,
                  elevation: 5,
                  padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                ),
                onPressed: scan,
                child: Text('START SCAN'),  
              )
            ),
          ],
        ),
      ),
    );
  }

  Future scan() async {
    try {
      List<String> result = await scanner.scan()
        .then((value) => List<String>.from(json.decode(value)));
      // final decrypted = _encrypter.decrypt(encr.Encrypted.fromBase64(this.cameraScanResult), iv: iv);
      this.cameraScanResult = "shopId: ${result[0]} tableId: ${result[1]}";
      AppUrls.setShopId = result[0];
      AppUrls.setTableId = result[1];

      // Navigator.push(context, MaterialPageRoute(builder: (context) => SuccessScreen(result: this.cameraScanResult)));
      Navigator.pushNamed(context, '/foodList');
      
    } on PlatformException catch (e) {
      if(e.code == scanner.CameraAccessDenied){
        setState(() {
          this.cameraScanResult = 'Camera access not granted';
        });
      } else {
        setState(() {
          this.cameraScanResult = 'Unknown platform Exception: $e';
        });
      }
      Navigator.push(context, MaterialPageRoute(builder: (context) => SuccessScreen(result: this.cameraScanResult)));
    } on FormatException{
      setState(() {
        this.cameraScanResult = 'User exited using back button or Wrong Scan';
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => SuccessScreen(result: this.cameraScanResult)));
    } catch (e) {
      setState(() {
        this.cameraScanResult = 'Unknown error or Wrong Scan';
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => SuccessScreen(result: this.cameraScanResult)));
    }
      
  }
}