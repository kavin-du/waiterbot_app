class AppUrls{
  // static String _shopId = "";
  static String _shopId = "6011648d4821223750da1ee9";
  static String _foodId = "";
  static String _tableId = "60142f05a4d38f09efe4fd96";

  static const String remoteBaseUrl = '';
  static const String localBaseUrl = 'http://10.0.2.2:3000/api';

  static const String baseUrl = localBaseUrl;

  static const String login = baseUrl + '/auth/client_login';
  static const String register = baseUrl + '/auth/client_register';

  // static String _shopInfo = baseUrl + '/properties/$_shopId'; 
  // static String _foodItems = baseUrl + '/properties/$_shopId/items';
  
  // static String _reviews = baseUrl + '/items/$_foodId/reviews';

  static set setShopId(String id) => _shopId = id;
  static get getShopId => _shopId;

  static set setFoodId(String id) => _foodId = id;
  static get getFoodId => _foodId;
  static get getTableId => _tableId;

  // * Url endpoints
  static get shopInfoUrl => (baseUrl + '/properties/$_shopId');
  static get foodItemsUrl => (baseUrl + '/properties/$_shopId/items');
  static get reviewsUrl => (baseUrl + '/items/$_foodId/reviews');
  static get placeOrder => (baseUrl + '/orders');
}