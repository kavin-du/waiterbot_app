import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final result; // do not remove

  SuccessScreen({this.result}); // do not remove
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi'),
      ),
      body: Center(
        child: Text(result.toString()),
      ) 
    );
  }



}