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
      AppUrls.shopInfoUrl,
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
        'message': json.decode(response.body)['message']
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
    Response response = await get(
      AppUrls.foodItemsUrl,
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
        'message': json.decode(response.body)['message']
      };
    }
    return result;

  }

  Future<Map<String, dynamic>> fetchReviews(String foodId) async {
    _fetchStatus = Status.Fetching;
    Map<String, dynamic> result;
    // String token;

    // await UserPreferences().getUser().then((user) => token = user.token);
    
    AppUrls.setFoodId = foodId;

    Response response = await get(
      AppUrls.reviewsUrl,
      headers: {
        "Authorization": "Bearer $token"
      }
    );
    if(response.statusCode == 200){
      // ? this was as map in above function
      final Map<String, dynamic> responseData = json.decode(response.body);

      _fetchStatus = Status.FetchComplete;
      // notifyListeners(); // ! if this removed additional calls removed?

      result = responseData;

    } else {
      _fetchStatus = Status.FetchFailed;
      // notifyListeners();
      result = {
        'success': false,
        'message': json.decode(response.body)['message']
      };
    }
    // print(result); 
    return result;
  }

  Future<Map<String, dynamic>> addReview(String foodId, String review, int stars) async {
    _fetchStatus = Status.Fetching;
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

      _fetchStatus = Status.FetchComplete;
      notifyListeners();

      result = responseData;
    } else {
      _fetchStatus = Status.FetchFailed;
      notifyListeners();
      result = {
        'success': false,
        'message': Map<String, dynamic>.from(json.decode(response.body))['message']
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> placeOrder(List<FoodItem> items, double total) async {
    _fetchStatus = Status.Fetching;
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

      _fetchStatus = Status.FetchComplete;
      // notifyListeners();
      result = responseData;
    } else {
      _fetchStatus = Status.FetchFailed;
      // notifyListeners();
      result = {
        "success": false,
        "message": json.decode(response.body)['message']
      };
    }
    return result;
  }

}
