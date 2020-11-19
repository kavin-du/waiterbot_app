import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:waiterbot_app/models/user_model.dart';


class UserPreferences {
  
  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('id', user.id); // double quote?
    prefs.setString('firstName', user.firstName);
    prefs.setString('lastName', user.lastName);
    prefs.setString('email', user.email);
    prefs.setString('mobileNumber', user.mobileNumber);
    prefs.setString('token', user.token);

    // return prefs.commit();
    return true;
  }
  
  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String id = prefs.getString('id'); // double quote?
    String firstName = prefs.getString('firstName');
    String lastName = prefs.getString('lastName');
    String email = prefs.getString('email');
    String mobileNumber = prefs.getString('mobileNumber');
    String token = prefs.getString('token');

    return User(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      mobileNumber: mobileNumber,
      token: token,
    );
 
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('id');
    prefs.remove('firstName');
    prefs.remove('lastName');
    prefs.remove('email');
    prefs.remove('mobileNumber');
    prefs.remove('token');
  }

  //   seperate function for get only the token
}