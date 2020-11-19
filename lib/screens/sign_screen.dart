import 'package:flushbar/flushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:waiterbot_app/mix_ins/validator_mixin.dart';
import 'package:waiterbot_app/models/user_model.dart';
import 'package:waiterbot_app/providers/auth_provider.dart';
import '../providers/sign_state_provider.dart';
import 'licence_agreement.dart';

class SignScreen extends StatelessWidget with ValidatorMixin {
  final _formKeySignUp = GlobalKey<FormState>();
  final _formKeySignIn = GlobalKey<FormState>();

  String _mobileNumber, _password;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height; 
    final width = MediaQuery.of(context).size.width; 

    void doLogin(){
      if(_formKeySignIn.currentState.validate()){
        _formKeySignIn.currentState.save();

        // check this....................listern false
        final Future<Map<String, dynamic>> successfulMessage = Provider.of<AuthProvider>(context, listen: false)
          .login(_mobileNumber, _password);

        successfulMessage.then((response) {
          if(response['status']){
            User user = response['user'];

            // Provider.of<UserProvider>(context, listen=false).setUser(user);
            Navigator.pushReplacementNamed(context, '/success');
          } else {
            // print(response);
            Flushbar(
              title:'Login Failed',
              message: response['message'],
              duration: Duration(seconds: 3),
            ).show(context);
          }
        });
      } else {
        print('invalid form');
      }
    
    }

    

  Widget buttonBar(SignStateProvider provider) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      buttonPadding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
      children: [
        RaisedButton(
          // sign up button
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.pink, width: 1.5)),
          color: provider.isSignUp ? Colors.pink : null,
          onPressed: () {
            provider.signUpScreen();
          },
          child: Text('Sign Up'),
        ),
        RaisedButton(
          // sign in button
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.pink, width: 1.5)),
          color: !provider.isSignUp ? Colors.pink : null,
          onPressed: () {
            provider.signInScreen();
          },
          child: Text('Sign In'),
        )
      ],
    );
  }

  Widget name(String value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 20, 0),
      child: TextFormField(
        validator: nameValidation,
        keyboardType: TextInputType.text, // optimize keyboard for name
        decoration: InputDecoration(
            // contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 35),   
            isDense: true,
            errorStyle: TextStyle(
              height: 0.4
            ),
            icon: Image(
              image: AssetImage(value == 'First Name'
                  ? 'images/icons/firstname.png'
                  : 'images/icons/lastname.png'),
            ),
            labelText: value,
            hintText: value == 'First Name' ? 'John' : 'Doe',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500, color: Colors.black, fontSize: 22)),
      ),
    );
  }


  Widget email() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 20, 0),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            isDense: true,
            errorStyle: TextStyle(
              height: 0.4
            ),
            icon: Image(
              image: AssetImage('images/icons/email.png'),
            ),
            labelText: 'E-Mail',
            hintText: 'example@email.com',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500, color: Colors.black, fontSize: 22)),
        validator: emailValidation,
        onSaved: (String value) {
          // invoke onSaved when formKey.currentState.Saved() calls          
          // print(value);
        },
      ),
    );
  }

  Widget loginPassword() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 20, 0),
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
            isDense: true,
            errorStyle: TextStyle(
              height: 0.4
            ),
            icon: Image(
              image: AssetImage('images/icons/password.png'),
            ),
            labelText: 'Password',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500, color: Colors.black, fontSize: 22)),
        validator: passwordValidation,
        onSaved: (String value) {
          // invoke onSaved when formKey.currentState.Saved() calls
          _password = value;
          // print(value);
        },
      ),
    );
  }

  Widget regPassword() {
    String _confirmPass = '';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 20, 0),
          child: TextFormField(
            obscureText: true,
            decoration: InputDecoration(
                isDense: true,
                errorStyle: TextStyle(
                  height: 0.4
                ),
                icon: Image(
                  image: AssetImage('images/icons/password.png'),
                ),
                labelText: 'Password',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.black, fontSize: 22)),
            validator: (String value){
              if(_confirmPass == value) return passwordValidation(value);
              return 'Passwords do not match';
            },
            onSaved: (String value) {
              // invoke onSaved when formKey.currentState.Saved() calls
              _password = value;
              // print(value);
            },
          ),
        ),
        Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 20, 0),
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
            isDense: true,
            errorStyle: TextStyle(
              height: 0.4
            ),
            icon: Image(
              image: AssetImage('images/icons/password.png'),
            ),
            labelText: 'Confirm Password',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500, color: Colors.black, fontSize: 22)),
        onChanged: (String value){
          _confirmPass = value;
        },
        // onSaved: (String value) {
        //   // invoke onSaved when formKey.currentState.Saved() calls
        //   _password = value;
        //   // print(value);
        // },
      ),
    )
      ],
    );
  }

  Widget mobileNumber() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 20, 0),
      child: TextFormField(
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            isDense: true,
            errorStyle: TextStyle(
              height: 0.4
            ),
            icon: Image(
              image: AssetImage('images/icons/phone.png'),
            ),
            labelText: 'Mobile Number',
            hintText: '0712345678',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500, color: Colors.black, fontSize: 22)),
        validator: phoneValidation,
        onSaved: (value) => _mobileNumber = value,
      ),
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

  Widget loading = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircularProgressIndicator(),
      Padding(padding: const EdgeInsets.only(left:5)),
      Text('Validating...Please wait')
    ],
  );

  Widget button(SignStateProvider provider) {
    return  Provider.of<AuthProvider>(context).loggedInStatus == Status.Authenticating ? loading : RaisedButton(
      elevation: 10,
      padding: EdgeInsets.fromLTRB(35, 10, 35, 10),
      child:Text(
        provider.isSignUp ? 'SIGN UP' : 'SIGN IN',
        style: TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        if (provider.isSignUp) {
          if (_formKeySignUp.currentState.validate() &&
              provider.checkBoxValue) {
            print("user validated, register");
            _formKeySignUp.currentState
                .save(); // this will call all onSaved() functions in form
          }
        } else {
          // if (_formKeySignIn.currentState.validate()) {
          //   print("user validated, log in");
          //   _formKeySignIn.currentState
          //       .save(); // this will call all onSaved() functions in form
          // }
          doLogin();
        }
      },
      color: Colors.amberAccent,
    );
  }



  Widget setContent(SignStateProvider provider) {
    if (provider.isSignUp) {
      return Wrap(
        alignment: WrapAlignment.center,
        children: [
          Image.asset(
            'images/waiterbot_logo.png',
            width: 100,
          ),
          buttonBar(provider),
          name('First Name'),
          name('Last Name'),
          //email(),
          mobileNumber(),
          regPassword(),
          Padding(padding: EdgeInsets.all(5)),
          checkbox(provider),
          Padding(padding: EdgeInsets.only(top: 30)),
          button(provider)
        ],
      );
    }
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Image.asset(
          'images/waiterbot_logo.png',
          width: 100,
        ),
        buttonBar(provider),
        mobileNumber(),
        loginPassword(),
        Padding(padding: EdgeInsets.only(bottom: 85)),
        button(provider)
      ],
    );
  }

    return Builder(
      builder: (BuildContext context) {
        return Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/sign_background.jpg'),
                    fit: BoxFit.fill)),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              // resizeToAvoidBottomInset: false, // prevent shrinking home screen image
              body: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: 25, left: 25, right: 25),
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  height: height-50,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.all(Radius.circular(65))),
                  child: SingleChildScrollView(
                    child: Container(                      
                      // margin: EdgeInsets.only(left: 45, right: 45, top: 35), // 45
                      child: Form(
                        key: Provider.of<SignStateProvider>(context).isSignUp ? _formKeySignUp : _formKeySignIn,
                        child: Consumer<SignStateProvider>(
                          builder: (context, provider, child) {
                            return setContent(provider);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
      },
    );
  }

  

  
}
