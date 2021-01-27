class AppUrls{
  static const String remoteBaseUrl = '';
  static const String localBaseUrl = 'http://10.0.2.2:3000/api';

  static const String baseUrl = localBaseUrl;

  static const String login = baseUrl + '/auth/client_login';
  static const String register = baseUrl + '/auth/client_register';
}