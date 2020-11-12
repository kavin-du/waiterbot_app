import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:encrypt/encrypt.dart' as encr;

import './success_screen.dart';

class QRScan extends StatefulWidget {
  @override
  _QRScanState createState() => _QRScanState();
}

class _QRScanState extends State<QRScan> {
  String cameraScanResult = '';

  String testWord = 'Hello machan'; // delete this
  final key = encr.Key.fromUtf8('my 32 length key................'); // generate this from server and get it
  final iv = encr.IV.fromLength(16);

  var _encrypter;
  var _encrypted;

  @override
  void initState() {    
    super.initState();

    _encrypter = encr.Encrypter(encr.AES(key));
    _encrypted = _encrypter.encrypt(testWord, iv: iv);


    print('encryp.......='+ _encrypted.base64.toString()); // delete

    final decrypted = _encrypter.decrypt(encr.Encrypted.fromBase64(_encrypted.base64.toString()), iv: iv); // delete

    print('decryp.............'+decrypted); // delete
  }

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
              child: RaisedButton(
                color: Colors.blue,
                textColor: Colors.white,
                splashColor: Colors.blueGrey,
                onPressed: scan,
                child: Text('START SCAN'),  
              )
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //   child: Text(cameraScanResult, textAlign: TextAlign.center),
            // )
          ],
        ),
      ),
    );
  }

  Future scan() async {
    try {
      this.cameraScanResult = await scanner.scan();
      final decrypted = _encrypter.decrypt(encr.Encrypted.fromBase64(this.cameraScanResult), iv: iv);
      Navigator.push(context, MaterialPageRoute(builder: (context) => SuccessScreen(result: decrypted.toString())));
      
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
    } on FormatException{
      setState(() {
        this.cameraScanResult = 'User exited using back button before scan anything';
      });
    } catch (e) {
      setState(() {
        this.cameraScanResult = 'Unknown error';
      });
    }
  }
}