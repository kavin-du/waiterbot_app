import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../mix_ins/validator_mixin.dart';
import 'signin.dart';

import '../screens/licence_agreement.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with ValidatorMixin {
  final formKey = GlobalKey<
      FormState>(); // we are not passing Form, FormState passing because it is stful widget

  bool checkBoxValue = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // appBar: AppBar(
        //   title: Text('Delete this bar'),
        //   backgroundColor: Colors.amber,
        // ),
       resizeToAvoidBottomInset: false, // prevent shrinking image when keyboard opens
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
                    borderRadius: BorderRadius.all(Radius.circular(65))
                  ),
              ),
              Container(                            
                margin: EdgeInsets.only(left: 45, right: 45, top: 35), // 45
                child: Form(
                  key: formKey,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [                      
                      Image.asset(
                        'images/waiterbot_logo.png',
                        width: 120,
                      ),
                      buttonBar(context),
                      name('First Name'),
                      name('Last Name'),
                      email(),
                      mobileNumber(),
                      Padding(padding: EdgeInsets.all(5)),
                      checkbox(this),
                      Padding(padding: EdgeInsets.only(top: 30)),
                      button()
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget name(String value) {
    return TextFormField(
      validator: nameValidation,
      keyboardType: TextInputType.name, // optimize keyboard for name
      decoration: InputDecoration(
          icon: Image(
            image: AssetImage(value == 'First Name'
                ? 'images/icons/firstname.png'
                : 'images/icons/lastname.png'),
          ),
          labelText: value,
          hintText: value == 'First Name' ? 'John' : 'Doe',
          labelStyle: TextStyle(
              fontWeight: FontWeight.w500, color: Colors.black, fontSize: 25)),
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
          ),
          color: Colors.pink,
          onPressed: () {},
          child: Text('Sign Up'),
        ),
        RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.pink, width: 1.5)),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignIn()));
          },
          child: Text('Sign In'),
        )
      ],
    );
  }

  Widget email() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          icon: Image(
            image: AssetImage('images/icons/email.png'),
          ),
          labelText: 'E MAIL',
          hintText: 'example@email.com',
          labelStyle: TextStyle(
              fontWeight: FontWeight.w500, color: Colors.black, fontSize: 25)),
      validator: emailValidation,
      onSaved: (String value) {
        // invoke onSaved when formKey.currentState.Saved() calls
        print(value);
      },
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

  Widget checkbox(_SignUpState parent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
            value: parent.checkBoxValue,
            onChanged: (bool value) {
              parent.setState(() {
                parent.checkBoxValue = value;
              });
              // print(parent.checkBoxValue);
            }),
        Licence(),
      ],
    );
  }

  Widget button() {
    return RaisedButton(
      
      elevation: 10,
      padding: EdgeInsets.fromLTRB(45, 10, 45, 10),
      child: Text(
        'SIGN UP',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        if (formKey.currentState.validate() && this.checkBoxValue) {
          print("user validated");
          formKey.currentState
              .save(); // this will call all onSaved() functions in form
        }
      },
      color: Colors.amberAccent,
    );
  }
}