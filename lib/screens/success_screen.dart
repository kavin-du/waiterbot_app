import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final result;

  SuccessScreen({this.result});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Success'),
      ),
      body: Center(
        child: Text(this.result),
      ),
    );
  }



}