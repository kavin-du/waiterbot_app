import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:waiterbot_app/models/user_model.dart';
import 'package:waiterbot_app/services/app_urls.dart';
import 'package:waiterbot_app/services/shared_preferences.dart';


enum Status{
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredStatus => _registeredStatus;


  Future<Map<String, dynamic>> login(String mobileNumber, String password) async {
    var result;

    final Map<String, dynamic> loginData = {
      'mobile': mobileNumber,
      'password': password
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    Response response = await post(
      AppUrls.login,
      body: json.encode(loginData),
      headers: {'Content-type': 'application/json'}
    );
    
    if(response.statusCode == 200){
      final Map<String, dynamic> responseData = json.decode(response.body);

      var userData = responseData; // ?

      User authUser = User.fromJson(userData);

      UserPreferences().saveUser(authUser);

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      result = {'status': true, 'message': 'Successful', 'user': authUser};


    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();

      result = {
        'status': false,
        'message': json.decode(response.body)['message'],
      };
    }

    return result;

  }

  Future<Map<String, dynamic>> register(String firstName, String lastName, String mobile, String password) async {

    var result;

    final Map<String, dynamic> registerData = {
      'first_name': firstName,
      'last_name' : lastName,
      'mobile': mobile,
      'password': password
    };

    _registeredStatus = Status.Authenticating;
    notifyListeners();

    Response response = await post(
      AppUrls.register,
      body: json.encode(registerData),
      headers: {'Content-type': 'application/json'}
    );

    if(response.statusCode == 201){
      final Map<String, dynamic> responseData = json.decode(response.body);

      var userData = responseData;

      User authUser = User.fromJson(userData);

      UserPreferences().saveUser(authUser);

      _registeredStatus = Status.Registered;
      notifyListeners();

      result = {'status': true, 'message': 'Register Successful', 'user': authUser};

    } else {
      _registeredStatus = Status.NotRegistered;
      notifyListeners();

      result = {
        'status': false,
        'message': json.decode(response.body)['message']
      };
    }
    return result;
  }
}