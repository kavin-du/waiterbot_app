import 'package:equatable/equatable.dart';

class FoodItem extends Equatable{
  String _name;
  String _category;
  int _units;
  String _selectedPortion;
  Map<String, double> _portions;

  FoodItem(String name, String category, Map<String, double> portions){
    _name = name;
    _category = category;
    _portions = portions;
  }

  FoodItem.forFinalOrder(FoodItem item, int units, String selectedPortion){
    _name = item.name;
    _category = item.category;
    _portions = item.portions;
    _units = units;
    _selectedPortion = selectedPortion;
  }

  // FoodItem.fromJson(Map<String, dynamic> parsedJson){
  //   _name = parsedJson['name'];
  //   _category = parsedJson['category'];
  //   _portions = parsedJson['portions'];
  // }

  String get name => _name;
  String get category => _category;
  int get units => _units;
  String get selectedPortion => _selectedPortion;
  Map<String, double> get portions => _portions;

  @override
  List<Object> get props => [_name, _category, _selectedPortion]; // only name and category ? is this safe? 

}