import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:waiterbot_app/models/food_model.dart';
import 'package:waiterbot_app/services/app_urls.dart';
import 'package:waiterbot_app/services/shared_preferences.dart';

enum Status { Fetching, FetchComplete, FetchFailed }
String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNjAxMTc0ZThkNjljODEyOWVjMzM1MjEwIiwicm9sZSI6ImNsaWVudCIsImlhdCI6MTYxMTg1MzU0NSwiZXhwIjoxNjEyNDU4MzQ1fQ.TsuPA7YzfU9Xn81OmjZp3RWCY-x5yjvccNS7e-H41Cc";

class FetchShopItems with ChangeNotifier {
  Status _fetchStatus = Status.Fetching;

  Status get fetchStatus => _fetchStatus;


  // TODO: no need to pass store id
  Future<Map<String, dynamic>> fetchShopInfo(String storeId) async {
    _fetchStatus = Status.Fetching;

    Map<String, dynamic> result;
    // String token;
    // await UserPreferences().getUser().then((user) => token = user.token);

    Response response = await get(
      AppUrls.shopInfo,
      headers: {
        "Authorization" : "Bearer $token"
      }
    );

    if(response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      
      _fetchStatus = Status.FetchComplete;
      notifyListeners();
      return responseData;
    
    } else {
      _fetchStatus = Status.FetchFailed;
      notifyListeners();

      result = {
        'success': false,
        'message': json.decode(response.body)
      };
    }
    // print(result);
    return result;
  }




  Future<Map<String, dynamic>> fetchFoods() async {
    _fetchStatus = Status.Fetching;
    var result;
    // String token;

    // TODO: error handling for token cactch
    // await UserPreferences().getUser().then((user) => token = user.token);
    Response response = await get(
      AppUrls.foodItems,
      headers: {
        "Authorization": "Bearer $token"
      }
    );

    if(response.statusCode == 200 || response.statusCode == 201){
      final Map<String, dynamic> responseData = json.decode(response.body) as Map<String, dynamic>;

      _fetchStatus = Status.FetchComplete;
      notifyListeners();

      result = responseData;
    } else {
      _fetchStatus = Status.FetchFailed;
      notifyListeners();

      result = {
        'success': false,
        'message': json.decode(response.body)
      };
    }
    // print(result);
    return result;

  }

}
