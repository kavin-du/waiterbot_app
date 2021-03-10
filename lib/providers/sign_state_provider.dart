

import 'package:flutter/cupertino.dart';

class SignStateProvider with ChangeNotifier{
  bool _signUp = true;
  bool _checkBoxValue = false;

  void signInScreen(){
    this._signUp = false;
    notifyListeners();
  } 

  void signUpScreen(){
    this._signUp = true;
    notifyListeners();
  }

  void setCheckBox(bool value){
    this._checkBoxValue = value;
    notifyListeners();
  }

  // notifyListeners();

  bool get isSignUp => _signUp;
  bool get checkBoxValue => _checkBoxValue;
}