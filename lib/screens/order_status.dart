import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waiterbot_app/providers/notification_provider.dart';

class OrderStatus extends StatefulWidget {
  final String token;

  const OrderStatus({Key key, this.token}) : super(key: key);

  @override
  _OrderStatusState createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> { 
  @override
  Widget build(BuildContext context) {
    NotificationProvider _notificationProvider = Provider.of<NotificationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your order placed successfully'),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: _notificationProvider.orderStatus.length,
          // itemCount: _notificationProvider.notifications.length,
          itemBuilder: (context, index){
            return Padding(
              padding: const EdgeInsets.all(6.0),
              child: ListTile(
                title: Text(_notificationProvider.orderStatus[index].toString()),
                // title: Text(_notificationProvider.notifications[index]),
                tileColor: Colors.purpleAccent,
              ),
            );
          },
        )
      ),
    );
  }
}


