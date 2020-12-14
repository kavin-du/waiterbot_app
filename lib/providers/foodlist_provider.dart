import 'package:flutter/cupertino.dart';

class FoodListProvider with ChangeNotifier {
  List<String> _foodlist = [];
  String _foodType = '';

  String get getFoodType => _foodType;
  List<String> get getFoodList => _foodlist;

  set setFoodType(String type) {
    _foodType = type;
    notifyListeners();
  }
  set setFoodList(List<String> foods){
    _foodlist = foods;
    notifyListeners();
  }
}