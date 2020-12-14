import 'package:flutter/cupertino.dart';
import 'package:waiterbot_app/models/food_model.dart';


class FinalOrdersProvider with ChangeNotifier {
  int _orderId = 1;
  Map<int, FoodItem> _orders = {};

  void addOrder(FoodItem item){
    // get the key of existing order
    if(_orders.keys != null){
      var key = _orders.keys.firstWhere((k) => _orders[k] == item, orElse: ()=> null); 
      if(key != null){
        _orders[key] = item;
      } else {
        _orders[_orderId] = item;
        _orderId++;
      }   
    } else {
      _orders[_orderId] = item;
      _orderId++;
    }
     
    notifyListeners();
  }

  void removeOrder(int id){
    _orders.remove(id);
    notifyListeners();
  }
  Map<int, FoodItem> get getOrders => _orders;
}