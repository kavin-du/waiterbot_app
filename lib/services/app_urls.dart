class AppUrls{
  static String _shopId = "";
  // static String _shopId = "6011648d4821223750da1ee9";
  static String _foodId = "";
  // static String _tableId = "6046050da8996e00152ea87b";
  static String _tableId = "";
  
  static const String websocketUrl = "http://waiterbot-api.us-east-1.elasticbeanstalk.com";
  static const String remoteBaseUrl = 'http://waiterbot-api.us-east-1.elasticbeanstalk.com/'+'api';

  // static const String websocketUrl = "https://waiterbot-api.herokuapp.com";
  static const String remoteBaseUrlHeroku = 'https://waiterbot-api.herokuapp.com/'+'api';

  // static const String websocketUrl = "http://10.0.2.2:3000";
  static const String localBaseUrl = 'http://10.0.2.2:3000/api';

  // static const String baseUrl = localBaseUrl;
  static const String baseUrl = remoteBaseUrl;
  // static const String baseUrl = remoteBaseUrlHeroku;

  static const String login = baseUrl + '/auth/client_login';
  static const String register = baseUrl + '/auth/client_register';

  static set setShopId(String id) => _shopId = id;
  static get getShopId => _shopId;

  static set setFoodId(String id) => _foodId = id;
  static get getFoodId => _foodId;

  static get getTableId => _tableId;
  static set setTableId(String id) => _tableId = id;

  // * Url endpoints
  static get shopInfoUrl => (baseUrl + '/properties/$_shopId');
  static get foodItemsUrl => (baseUrl + '/properties/$_shopId/items');
  static get reviewsUrl => (baseUrl + '/items/$_foodId/reviews');
  static get placeOrder => (baseUrl + '/orders');
}