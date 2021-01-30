import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waiterbot_app/custom_widgets/custom_appbar.dart';
import 'package:waiterbot_app/providers/notification_provider.dart';

class Notifications extends StatelessWidget {
  const Notifications({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
        ),
        body: ListView.builder(
          itemCount: _notificationProvider.notifications.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Card(
                color: Colors.white70,
                child: Text(
                  _notificationProvider.notifications[index],
                  style: TextStyle(fontSize: 20),
                ),
              ),
            );
          },
        ));
  }
}
