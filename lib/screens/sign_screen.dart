import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:waiterbot_app/mix_ins/validator_mixin.dart';
import '../providers/sign_state_provider.dart';
import 'licence_agreement.dart';

class SignScreen extends StatelessWidget with ValidatorMixin {
  final _formKeySignUp = GlobalKey<FormState>();
  final _formKeySignIn = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignStateProvider>(
      create: (context) =>SignStateProvider(),
      child: Builder(
        builder: (context) {
          return MaterialApp(
            home: Scaffold(
              resizeToAvoidBottomInset: false, // prevent shrinking home screen image
              body: Stack(
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
                  key: _formKeySignUp,
                  child: Consumer<SignStateProvider>(
                    builder: (context, provider, child){
                      return setContent(provider);
                    },
                  ), 
                ),
              ),
            ],
          ),
            ),
          );
        },
      ),

    );
  }

  Widget setContent(SignStateProvider provider){
    if(provider.isSignUp){
      return Wrap(
        alignment: WrapAlignment.center,
        children: [                      
          Image.asset(
            'images/waiterbot_logo.png',
            width: 120,
          ),
          buttonBar(provider),
          name('First Name'),
          name('Last Name'),
          email(),
          mobileNumber(),
          Padding(padding: EdgeInsets.all(5)),
          checkbox(provider),
          Padding(padding: EdgeInsets.only(top: 30)),
          button(provider)
        ],);
    }
    return Wrap(
        alignment: WrapAlignment.center,
        children: [                      
          Image.asset(
            'images/waiterbot_logo.png',
            width: 120,
          ),
          buttonBar(provider),
          mobileNumber(),
          Padding(padding: EdgeInsets.only(bottom: 85)),
          button(provider)
        ],);
      
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

  Widget buttonBar(SignStateProvider provider) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      buttonPadding: EdgeInsets.only(left: 30, right: 30),
      children: [
        RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.pink,
          onPressed: () {
            provider.signUpScreen();
          },
          child: Text('Sign Up'), 
        ),
        RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.pink, width: 1.5)),
          onPressed: () {
            provider.signInScreen();
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

  Widget checkbox(SignStateProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
            value: provider.checkBoxValue, // ?
            onChanged: (bool value) {
              provider.setCheckBox(value);
              // print(parent.checkBoxValue);
            }),
        Licence(),
      ],
    );
  }

  Widget button(SignStateProvider provider) {
    return RaisedButton(
      
      elevation: 10,
      padding: EdgeInsets.fromLTRB(45, 10, 45, 10),
      child: Text(
        provider.isSignUp ? 'SIGN UP' : 'SIGN IN',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        if(provider.isSignUp) {
          if (_formKeySignUp.currentState.validate() && provider.checkBoxValue) {
            print("user validated, register");
            _formKeySignUp.currentState.save(); // this will call all onSaved() functions in form
          }
        } else {
          if (_formKeySignUp.currentState.validate()) {
            print("user validated, log in");
            _formKeySignUp.currentState.save(); // this will call all onSaved() functions in form
          }
        }
      },
      color: Colors.amberAccent,
    );
  }

}