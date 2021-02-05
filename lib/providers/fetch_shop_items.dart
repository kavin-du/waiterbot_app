import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:waiterbot_app/models/food_model.dart';
import 'package:waiterbot_app/services/app_urls.dart';
import 'package:waiterbot_app/services/shared_preferences.dart';

enum Status { Fetching, FetchComplete, FetchFailed }

class FetchShopItems with ChangeNotifier {
  Status _fetchStatus = Status.Fetching;
  static String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNjAxMTc0ZThkNjljODEyOWVjMzM1MjEwIiwicm9sZSI6ImNsaWVudCIsImlhdCI6MTYxMjI2MjE5NiwiZXhwIjoxNjEyODY2OTk2fQ.GkanXa-ZsjWFH7e49_uWA1NC8i8qCHt2XeaQIo99PcY";

  Status get fetchStatus => _fetchStatus;
  
  Future<Map<String, dynamic>> fetchShopInfo() async {
    _fetchStatus = Status.Fetching;

    Map<String, dynamic> result;
    // String token;
    // await UserPreferences().getUser().then((user) => token = user.token);

    try{
      Response response = await get(
        AppUrls.shopInfoUrl,
        headers: {
          "Authorization" : "Bearer $token"
        }
      ).timeout(Duration(seconds: 5));

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
          'message': json.decode(response.body)['message']
        };
      }
    } on TimeoutException catch(e){
      result = {
        'success': false,
        'message': 'Connection failed. Check your connection.'
      };
    } on Exception catch(e) {
      result = {
        'success': false,
        'message': e.toString(),
      };
    }    
    return result;
  }

  Future<Map<String, dynamic>> fetchFoods() async {
    _fetchStatus = Status.Fetching;
    var result;
    // String token;

    // TODO: error handling for token cactch
    // await UserPreferences().getUser().then((user) => token = user.token);

    try{
      Response response = await get(
        AppUrls.foodItemsUrl,
        headers: {
          "Authorization": "Bearer $token"
        }
      ).timeout(Duration(seconds: 5));

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
          'message': json.decode(response.body)['message']
        };
      }
    } on TimeoutException catch(e){
      result = {
        'success': false,
        'message': 'Connection failed. Check your connection'
      };

    } on Exception catch(e){
      result = {
        'success': false,
        'message': e.toString(),
      };
    }
    
    return result;

  }

  Future<Map<String, dynamic>> fetchReviews(String foodId) async {
    Map<String, dynamic> result;

    // String token;
    
    // await UserPreferences().getUser().then((user) => token = user.token);
    
    AppUrls.setFoodId = foodId;

    try {
      Response response = await get(
        AppUrls.reviewsUrl,
        headers: {
          "Authorization": "Bearer $token"
        }
      ).timeout(Duration(seconds: 4));

      if(response.statusCode == 200){
        final Map<String, dynamic> responseData = json.decode(response.body);
        result = responseData;
      } else {
        result = {
          'success': false,
          'message': json.decode(response.body)['message']
        };
      }
    } on TimeoutException catch(e) {
      result = {
        'success': false,
        'message': 'Connection failed. Check your connection.'
      };
    } on Exception catch(e) {
      result = {
        'success': false,
        'message': e.toString(),
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> addReview(String foodId, String review, int stars) async {
    Map<String, dynamic> result;
    // String token;

    // await UserPreferences().getUser().then((user) => token = user.token);

    AppUrls.setFoodId = foodId;
    Response response = await post(
      AppUrls.reviewsUrl,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "stars": stars,
        "comment": review
      })
    );
    
    if(response.statusCode == 201){
      final Map<String, dynamic> responseData = json.decode(response.body);
      result = responseData;
    } else {
      result = {
        'success': false,
        'message': Map<String, dynamic>.from(json.decode(response.body))['message']
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> placeOrder(List<FoodItem> items, double total) async {
    Map<String, dynamic> result;
    // String token;

    // await UserPreferences().getUser().then((user) => token = user.token);

    List<Map<String, dynamic>> orderItems = items
    .map((value) => {"item": value.foodId, "portion": value.portionId, "qty": value.units}).toList();

    // ! check total is double or int
    Map<String, dynamic> jsonBody = {
      "property": AppUrls.getShopId,
      "amount": total,
      "table": AppUrls.getTableId,
      "items": orderItems,
    };

    Response response = await post(
      AppUrls.placeOrder,
      headers: {
        "Authorization": "Bearer $token", 
        "Content-Type": "application/json"
      },
      body: jsonEncode(jsonBody)
    );

    if(response.statusCode == 200 || response.statusCode == 201){
      final Map<String, dynamic> responseData = json.decode(response.body);

      result = responseData;
    } else {
      result = {
        "success": false,
        "message": json.decode(response.body)['message']
      };
    }
    return result;
  }

}
