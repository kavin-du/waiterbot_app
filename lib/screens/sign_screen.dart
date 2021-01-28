import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:waiterbot_app/mix_ins/validator_mixin.dart';
import 'package:waiterbot_app/models/user_model.dart';
import 'package:waiterbot_app/providers/auth_provider.dart';
import '../providers/sign_state_provider.dart';
import 'licence_agreement.dart';

class SignScreen extends StatefulWidget {
  @override
  _SignScreenState createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> with ValidatorMixin {
  final _formKeySignUp = GlobalKey<FormState>();
  final _formKeySignIn = GlobalKey<FormState>();

  final _confirmPassController = TextEditingController();

  String _firstName, _lastName, _mobileNumber, _password;

  @override
  void dispose(){
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height; 
    final width = MediaQuery.of(context).size.width; 

    void doLogin(){
      if(_formKeySignIn.currentState.validate()){
        _formKeySignIn.currentState.save();

        // check this........listern false
        final Future<Map<String, dynamic>> successfulMessage = Provider.of<AuthProvider>(context, listen: false)
          .login(_mobileNumber, _password);

        successfulMessage.then((response) {
          if(response['status']){
            User user = response['user'];

            // Provider.of<UserProvider>(context, listen=false).setUser(user);
            Navigator.pushReplacementNamed(context, '/enterShopId');
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

    void doRegister(){
      
      if(_formKeySignUp.currentState.validate() && Provider.of<SignStateProvider>(context, listen:false).checkBoxValue){
        _formKeySignUp.currentState.save();

        // check this....................listern false
        final Future<Map<String, dynamic>> successfulMessage = Provider.of<AuthProvider>(context, listen: false)
          .register(_firstName, _lastName, _mobileNumber, _password);

        successfulMessage.then((response) {
          if(response['status']){
            User user = response['user'];

            // Provider.of<UserProvider>(context, listen=false).setUser(user);

            Provider.of<SignStateProvider>(context, listen: false).signInScreen();
            Navigator.pushReplacementNamed(context, '/imageSlides');
            Flushbar(
              title:'Please LogIn.',
              message: response['message'],
              duration: Duration(seconds: 5),
            ).show(context);

          } else {
            // print(response);
            Flushbar(
              title:'Registering Failed',
              message: response['message'],
              duration: Duration(seconds: 3),
            ).show(context);
          }
        });
      } else {
        print('invalid form');
      }
    
    }

    

  Widget buttonBar() {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      buttonPadding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
      children: [
        RaisedButton(
          // sign up button
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.pink, width: 1.5)),
          color: Provider.of<SignStateProvider>(context, listen: false).isSignUp ? Colors.pink : null,
          onPressed: () {
            Provider.of<SignStateProvider>(context, listen: false).signUpScreen();
            _confirmPassController.clear();
          },
          child: Text('Sign Up'),
        ),
        RaisedButton(
          // sign in button
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.pink, width: 1.5)),
          color: !(Provider.of<SignStateProvider>(context, listen: false).isSignUp) ? Colors.pink : null,
          onPressed: () {
            Provider.of<SignStateProvider>(context, listen: false).signInScreen();
          },
          child: Text('Sign In'),
        )
      ],
    );
  }

  Widget firstName() {
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
              image: AssetImage('images/icons/firstname.png'),
            ),            
            labelText: 'First Name',
            hintText: 'John',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500, color: Colors.black, fontSize: 22)
        ),
        onSaved: (String value){
          _firstName = value;
        },
      ),
      
    );
  }

  Widget lastName() {
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
              image: AssetImage('images/icons/lastname.png'),
            ),
            labelText: 'Last Name',
            hintText: 'Doe',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500, color: Colors.black, fontSize: 22)
        ),
        onSaved: (String value){
          _lastName = value;
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
              print(_confirmPassController.text);
              print(value);
              if(_confirmPassController.text == value) return passwordValidation(value);
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
        controller: _confirmPassController,
        decoration: InputDecoration( 
            isDense: true,
            errorStyle: TextStyle(
              height: 0.4
            ),
            icon: Image(
              height: 50,
              image: AssetImage('images/icons/confirmpass.png'),
            ),
            labelText: 'Confirm Password',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500, color: Colors.black, fontSize: 22)),
        // onChanged: (String value){
        //   _confirmPass = value;
        // },
        // onSaved: (String value){
        //   _confirmPass = value;
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

  Widget checkbox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
            value: Provider.of<SignStateProvider>(context, listen: false).checkBoxValue, // ?
            onChanged: (bool value) {
              Provider.of<SignStateProvider>(context, listen: false).setCheckBox(value);
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

  Widget button() {
    var loggedInStatus = Provider.of<AuthProvider>(context).loggedInStatus;
    var registeredStatus = Provider.of<AuthProvider>(context).registeredStatus;
    return  loggedInStatus == Status.Authenticating || registeredStatus == Status.Authenticating ? loading : RaisedButton(
      elevation: 10,
      padding: EdgeInsets.fromLTRB(35, 10, 35, 10),
      child:Text(
        Provider.of<SignStateProvider>(context, listen: false).isSignUp ? 'SIGN UP' : 'SIGN IN',
        style: TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        if (Provider.of<SignStateProvider>(context, listen: false).isSignUp) {        
          doRegister();
        } else {         
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
          buttonBar(),
          firstName(),
          lastName(),
          mobileNumber(),
          regPassword(),
          Padding(padding: EdgeInsets.all(5)),
          checkbox(),
          Padding(padding: EdgeInsets.only(top: 30)),
          button()
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
        buttonBar(),
        mobileNumber(),
        loginPassword(),
        Padding(padding: EdgeInsets.only(bottom: 85)),
        button()
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
