import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../mix_ins/validator_mixin.dart';

class OTP extends StatefulWidget {
  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> with ValidatorMixin {
  final formKey = GlobalKey<
      FormState>(); // we are not passing Form, FormState passing because it is stful widget

  String otpValue = '';
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
            Container(
              margin: EdgeInsets.all(25),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.all(Radius.circular(65))),
            ),
            Container(
              margin: EdgeInsets.only(left: 45, right: 45, top: 35),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    topText(),
                    pincode(context),
                    Padding(padding: const EdgeInsets.only(bottom: 20)),
                    Text(
                      'Didn\'t receive the OTP?',
                      style: TextStyle(fontSize: 17),
                    ),
                    bottomText(),
                    Padding(padding: const EdgeInsets.only(bottom: 45)),
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

  Widget topText() {
    return Column(
      children: [
        Padding(padding: EdgeInsets.only(top: 20)),
        Text(
          'Verify Your Mobile Number',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        Padding(padding: EdgeInsets.only(top: 15)),
        Center(
          child: Image.asset('images/icons/otp.png'),
        ),
        Padding(padding: EdgeInsets.only(top: 15)),
        Text(
          'A verification code has been sent to your mobile number.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 17),
        ),
      ],
    );
  }

  Widget pincode(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 25),
        child: PinCodeTextField(
          appContext: context,
          length: 4,
          showCursor: true,
          cursorColor: Colors.black,
          obscureText: false,
          animationType: AnimationType.fade,
          backgroundColor: Colors.transparent,
          validator: otpValidator,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            fieldHeight: 60,
            fieldWidth: 50,
            selectedFillColor: Colors.green,
            inactiveFillColor: Colors.green,
            inactiveColor: Colors.green,
            // activeFillColor: hasError ? Colors.orange : Colors.white,
          ),
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          enableActiveFill: true,
          keyboardType: TextInputType.number,
          onCompleted: (v) => print("Completed"),
          onChanged: (value) {
            setState(() {
              this.otpValue = value;
            });
            print(this.otpValue);
          },
        ));
  }

  Widget bottomText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('images/icons/resend.png'),
        Padding(padding: EdgeInsets.all(3),),
        RichText(
          text: TextSpan(
          style: TextStyle(
              color: Colors.blueAccent,
              decoration: TextDecoration.underline,
              fontSize: 17),
          text: 'Resend Again',
          recognizer: TapGestureRecognizer()
            ..onTap = () => {/* url to launch when tap */},
          ),
        )
      ],
    );
  }

  // delete this after check validator
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
        'CONTINUE',
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
