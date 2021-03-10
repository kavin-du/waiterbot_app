import 'package:flutter/material.dart';

// @description
class ErrorScreen extends StatelessWidget {
  final String _text;

  const ErrorScreen([this._text]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Text(
          this._text,          
          style: TextStyle(
            fontSize: 25
          ),
        ),
      ),
    );
  }
}