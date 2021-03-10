import 'package:equatable/equatable.dart';

class FoodItem extends Equatable{
  String _name;
  String _category;
  int _units;
  String _selectedPortion;
  List<Map<String, dynamic>> _portions;
  String _image;
  int _stars;
  int _reviewCount;
  String _foodId;
  List<String> _ingredients;
  String _portionId;

  FoodItem(String name, String category, List<Map<String, dynamic>> portions, String image){
    _name = name;
    _category = category;
    _portions = portions;
    _image = image;
  }

  FoodItem.forFinalOrder(FoodItem item, int units, String selectedPortion){
    _name = item.name;
    _portionId = item.portions.firstWhere((value) => value['name'] == selectedPortion)['_id'];
    _foodId = item.foodId;
    _category = item.category;
    _portions = item.portions;
    _units = units;
    _selectedPortion = selectedPortion;
    _image = item.image;
    _stars = item.stars;
    _reviewCount = item.reviewCount;
    _ingredients = item.ingredients;
  }

  FoodItem.fromJson(Map<String, dynamic> parsedJson){
    _name = parsedJson['name'];
    _category = parsedJson['category'];
    _portions = List<Map<String, dynamic>>.from(parsedJson['portions']);
    _ingredients = List<String>.from(parsedJson['ingredients']);
    _image = parsedJson['imgUrl'];
    _stars = parsedJson['stars'];
    _reviewCount = parsedJson['review_count'];
    _foodId = parsedJson['_id'];
  }

  String get name => _name;
  String get category => _category;
  String get portionId => _portionId;
  String get image => _image;
  String get foodId => _foodId;
  int get units => _units;
  int get stars => _stars;
  int get reviewCount => _reviewCount;
  String get selectedPortion => _selectedPortion;
  List<Map<String, dynamic>> get portions => _portions;
  List<String> get ingredients => _ingredients;

  @override
  List<Object> get props => [_name, _category, _selectedPortion]; // only name and category ? is this safe? 

}