import 'package:flutter/cupertino.dart';
import 'package:waiterbot_app/models/food_model.dart';

class FoodListProvider with ChangeNotifier {
  Map<String, List<FoodItem>> _foodlist = {};
  String _foodType = '';
  bool _alreadySet = false;

  String get getFoodType => _foodType;
  List<FoodItem> getFoodList(String category) => _foodlist[category];

  set setFoodType(String type) {
    _foodType = type;
    notifyListeners();
  }
  set setFoodList(List<FoodItem> foods){
    if(_alreadySet == false){
      foods.forEach((foodItem){
        if(_foodlist.containsKey(foodItem.category)){
          _foodlist[foodItem.category].add(foodItem);
        } else {
          _foodlist[foodItem.category] = []; // ? initialing without a type
          _foodlist[foodItem.category].add(foodItem);
        }
      });
      _alreadySet = true;
    } 
    // notifyListeners();
  }
}