import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:waiterbot_app/models/user_model.dart';
import 'package:waiterbot_app/providers/notification_provider.dart';
import 'package:waiterbot_app/services/app_urls.dart';
import 'package:waiterbot_app/services/shared_preferences.dart';

enum Status {
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
  
  NotificationProvider notificationProvider;

  Future<Map<String, dynamic>> login(BuildContext context,
      String mobileNumber, String password) async {
    var result;
     notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    final Map<String, dynamic> loginData = {
      'mobile': mobileNumber,
      'password': password
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    try {
      Response response = await post(AppUrls.login,
        body: json.encode(loginData),
        headers: {'Content-type': 'application/json'}).timeout(Duration(seconds: 4));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        var userData = responseData; // ?

        User authUser = User.fromJson(userData);

        UserPreferences().saveUser(authUser);

        _loggedInStatus = Status.LoggedIn;
        notifyListeners();
        notificationProvider.connectToSocket(userData['token']);
        print(userData['token'].toString());
        result = {'success': true, 'message': 'Successful'};
        
      } else {
        _loggedInStatus = Status.NotLoggedIn;
        notifyListeners();
        result = {
          'success': false,
          'message': json.decode(response.body)['message'],
        };
      }
    } on TimeoutException catch(e){
      _loggedInStatus = Status.NotLoggedIn;
        notifyListeners();
        result = {
          'success': false,
          'message':'Connection failed. Check your connection.',
        };
    } on Exception catch(e){
      _loggedInStatus = Status.NotLoggedIn;
        notifyListeners();
        result = {
          'success': false,
          'message': e.toString(),
        };
    }
    

    return result;
  }

  Future<Map<String, dynamic>> register(
      String firstName, String lastName, String mobile, String password) async {
    var result;

    final Map<String, dynamic> registerData = {
      'first_name': firstName,
      'last_name': lastName,
      'mobile': mobile,
      'password': password
    };

    _registeredStatus = Status.Authenticating;
    notifyListeners();
    
    try {
      Response response = await post(AppUrls.register,
        body: json.encode(registerData),
        headers: {'Content-type': 'application/json'}).timeout(Duration(seconds: 4));

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        var userData = responseData;

        User authUser = User.fromJson(userData);

        UserPreferences().saveUser(authUser);

        _registeredStatus = Status.Registered;
        notifyListeners();

        result = {
          'success': true,
          'message': 'Register Successful',
        };
      } else {
        _registeredStatus = Status.NotRegistered;
        notifyListeners();

        result = {
          'success': false,
          'message': json.decode(response.body)['message']
        };
      }
    } on TimeoutException catch(e) {
      _registeredStatus = Status.NotRegistered;
      notifyListeners();

      result = {
        'success': false,
        'message': 'Connection failed. Check your connection.'
      };
    } on Exception catch(e){
      _registeredStatus = Status.NotRegistered;
      notifyListeners();

      result = {
        'success': false,
        'message': e.toString(),
      };
    }
    
    return result;
  }
}
