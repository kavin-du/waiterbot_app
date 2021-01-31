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
    final _height = MediaQuery.of(context).size.height;
    NotificationProvider _notificationProvider = Provider.of<NotificationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your order placed successfully'),
      ),
      body: Container(
        height: _height,
        child: Column(
          children: [
            Container(
              height: 50,
              alignment: Alignment.center,
              padding: EdgeInsets.all(5),
              child: CircularProgressIndicator(),
            ),
            Container(
              height: 400,
              child: ListView.builder(
                itemCount: _notificationProvider.orderStatus.length,
                itemBuilder: (context, index){
                  return Container(
                    height: 60,
                    padding: const EdgeInsets.all(6.0),
                    child: ListTile(
                      title: Text(_notificationProvider.orderStatus[index].toString()),
                      tileColor: Colors.purpleAccent,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


