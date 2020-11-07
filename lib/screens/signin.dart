import 'dart:ui';

import 'package:flutter/material.dart';
import '../mix_ins/validator_mixin.dart';
import './signup.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with ValidatorMixin {
  final formKey = GlobalKey<
      FormState>(); // we are not passing Form, FormState passing because it is stful widget

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // prevent shrinking image when keyboard opens
      body: Builder(builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'images/sign_background.jpg',
                fit: BoxFit.fitHeight,
              ),
            ),
            // BackdropFilter(
            //   filter: ImageFilter.blur(
            //     sigmaX: 5,
            //     sigmaY: 5,
            //   ),
            //   child: Container(
            //   // color: Colors.white,
            //   margin: EdgeInsets.all(25),
            //   decoration: BoxDecoration(
            //     color: Colors.black.withOpacity(0),
            //     borderRadius: BorderRadius.all(Radius.circular(30))
            //   ),
            // ),
            // ),
            Container(
              // color: Colors.white,
              margin: EdgeInsets.all(25),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(45))),
            ),
            Container(
              margin: EdgeInsets.all(25),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    buttonBar(context), 
                    mobileNumber(), 
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                    ),
                    button()
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget buttonBar(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      buttonPadding: EdgeInsets.only(left: 30, right: 30),
      children: [
        RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.pink, width: 1.5)
          ),
          onPressed: () {
            // Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignUp()));
          },
          child: Text('Sign Up'),
        ),
        RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),
          color: Colors.pink,
          onPressed: () {},
          child: Text('Sign In'),
        )
      ],
    );
  }

  Widget mobileNumber() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
          icon: Image(
            image: AssetImage('images/icons/phone.png'),
          ),
          labelText: 'MOBILE NUMBER',
          hintText: '0712345678',
          labelStyle: TextStyle(
              fontWeight: FontWeight.w500, color: Colors.black, fontSize: 25)),
      validator: phoneValidation,
    );
  }

  Widget button() {
    return RaisedButton(
      elevation: 10,
      padding: EdgeInsets.fromLTRB(45, 10, 45, 10),
      child: Text(
        'SIGN IN',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        if (formKey.currentState.validate()) {
          formKey.currentState
              .save(); // this will call all onSaved() functions in form
        }
      },
      color: Colors.amberAccent,
    );
  }
}
