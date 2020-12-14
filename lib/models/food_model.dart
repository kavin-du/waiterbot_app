
class FoodItem{
  String _name;
  String _category;
  Map<String, double> _portions;

  FoodItem(String name, String category, Map<String, double> portions){
    _name = name;
    _category = category;
    _portions = portions;
  }

  FoodItem.fromJson(Map<String, dynamic> parsedJson){
    _name = parsedJson['name'];
    _category = parsedJson['category'];
    _portions = parsedJson['portions'];
  }

  String get name => _name;
  String get category => _category;
  Map<String, double> get portions => _portions;
}