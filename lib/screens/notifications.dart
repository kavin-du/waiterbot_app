import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waiterbot_app/custom_widgets/custom_appbar.dart';
import 'package:waiterbot_app/providers/notification_provider.dart';

class Notifications extends StatelessWidget {
  const Notifications({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
        ),
        body: ListView.builder(
          itemCount: _notificationProvider.notifications.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: _height * 0.0678,
              margin: EdgeInsets.fromLTRB(_height * 0.01356, _height * 0.00678, _height * 0.01356, _height * 0.00678),
              child: Card(
                color: Colors.greenAccent,
                elevation: 8,
                child: Text(
                  _notificationProvider.notifications[index],
                  style: TextStyle(fontSize: _height * 0.02712),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ));
  }
}
