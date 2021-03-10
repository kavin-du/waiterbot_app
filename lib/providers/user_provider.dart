

import 'package:flutter/cupertino.dart';
import 'package:waiterbot_app/models/user_model.dart';


// ! where is this class used? 
class UserProvider with ChangeNotifier {
  User _user = new User();

  User get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}