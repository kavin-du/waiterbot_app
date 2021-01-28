class AppUrls{
  // static String _shopId = "";
  static String _shopId = "6011648d4821223750da1ee9";

  static const String remoteBaseUrl = '';
  static const String localBaseUrl = 'http://10.0.2.2:3000/api';

  static const String baseUrl = localBaseUrl;

  static const String login = baseUrl + '/auth/client_login';
  static const String register = baseUrl + '/auth/client_register';

  static String shopInfo = baseUrl + '/properties/$_shopId'; 
  static String foodItems = baseUrl + '/properties/$_shopId/items';
  
  static set setShopId(String id) => _shopId = id;
  static get getShopId => _shopId;
}