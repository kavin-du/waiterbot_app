import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../services/app_urls.dart';

class PushNotifications{
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  PushNotifications(){
    flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
      // var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher'); // ! change the icons name ?
      var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOs);

    flutterLocalNotificationsPlugin.initialize(initSetttings);

    // flutterLocalNotificationsPlugin.initialize(initSetttings,
    //     onSelectNotification: onSelectNotification);
  }

  // Future onSelectNotification(String payload) {
  //   Navigator.of(context).push(MaterialPageRoute(builder: (_) {
  //     return NewScreen(
  //       payload: payload,
  //     );
  //   }));
  // }

  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  showNotification(String description) async {
    var android = new AndroidNotificationDetails(
        'id', 'channel ', 'description',
        priority: Priority.High, importance: Importance.Max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, 'Hi there!', description, platform,
        payload: 'Welcome to the Local Notification demo');
  }

}

class NotificationProvider with ChangeNotifier {
  final pushNotifications = PushNotifications();
  int _notifiCount = 0;
  IO.Socket _socket;
  List<String> _notifications = [];
  List<String> _orderStatus = [];

  int get notifyCount => _notifiCount;
  IO.Socket get socket => _socket;
  List<String> get notifications => _notifications;
  List<String> get orderStatus => _orderStatus;

  void connectToSocket(token) {
    _socket = IO.io(AppUrls.websocketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      "query": {
        "token": token
      },
    });

    _socket.onConnect((_) {
      print('connect');
      _notifiCount++;
      _notifications.add("Hello there! Hope you're Safe!");
      pushNotifications.showNotification("Hello there! Hope you're Safe!");
      print('successfully connected to ws!');
      notifyListeners();
    });

    _socket.onError((data) {
      print("CONNECTION ERROR");
      _notifications.add("Oops! We'll get back to you soon.");
      notifyListeners();
      print(data);
    });

    _socket.on("join", (data) {
      print("PRIVATE");
      print(data);
    });

    _socket.on("orderStateChange", (data) {
      _notifiCount++;
      _notifications.add("Your order is "+data['status'].toString());
      _orderStatus.add(data['status'].toString());
      pushNotifications.showNotification("Your order is "+data['status'].toString());
      notifyListeners();

      print(data['status'].toString());

      print("ORDER STATE CHANGE");
    });
  }

  void onViewNotification(){
    _notifiCount = 0;
    notifyListeners();
  }
}
