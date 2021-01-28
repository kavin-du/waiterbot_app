import 'package:equatable/equatable.dart';

class FoodItem extends Equatable{
  String _name;
  String _category;
  int _units;
  String _selectedPortion;
  List<Map<String, dynamic>> _portions;
  String _image;
  int _stars;
  int _review_count;

  FoodItem(String name, String category, List<Map<String, dynamic>> portions, String image){
    _name = name;
    _category = category;
    _portions = portions;
    _image = image;
  }

  FoodItem.forFinalOrder(FoodItem item, int units, String selectedPortion){
    _name = item.name;
    _category = item.category;
    _portions = item.portions;
    _units = units;
    _selectedPortion = selectedPortion;
  }

  FoodItem.fromJson(Map<String, dynamic> parsedJson){
    _name = parsedJson['name'];
    _category = parsedJson['category'];
    _portions = List<Map<String, dynamic>>.from(parsedJson['portions']);
    _image = parsedJson['imgUrl'];
    _stars = parsedJson['stars'];
    _review_count = parsedJson['review_count'];
  }

  String get name => _name;
  String get category => _category;
  String get image => _image;
  int get units => _units;
  int get stars => _stars;
  int get reviewCount => _review_count;
  String get selectedPortion => _selectedPortion;
  List<Map<String, dynamic>> get portions => _portions;

  @override
  List<Object> get props => [_name, _category, _selectedPortion]; // only name and category ? is this safe? 

}