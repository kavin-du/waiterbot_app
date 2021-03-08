import 'dart:io';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waiterbot_app/providers/notification_provider.dart';
import 'package:waiterbot_app/screens/feedbacks.dart';

class OrderStatus extends StatefulWidget {
  final String token; // ! token is not used anywhere

  const OrderStatus({Key key, this.token}) : super(key: key);

  @override
  _OrderStatusState createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  final Map<String, FlareActor> _animations = {
    'Pending':
        FlareActor("animations/Liquid_Loader.flr", animation: "Untitled"),
    'Preparing': FlareActor("animations/Sushi.flr", animation: "Sushi Bounce"),
    'Delivering': FlareActor("animations/Robot.flr", animation: "reposo"),
    'Delivered':
        FlareActor("animations/success_check.flr", animation: "Untitled"),
    'Cancelled': FlareActor("animations/cancel_button.flr", animation: "Error"),
  };
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    NotificationProvider _notificationProvider =
        Provider.of<NotificationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Order has been Placed',
          style: TextStyle(
            fontSize: _height * 0.02712,
          ),
        ),
      ),
      backgroundColor: Colors.amber[300],
      body: Container(
        height: _height, // WTF?
        child: Column(
          children: [
            Container(
              height: 60,
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 10),
                  Text(
                    _notificationProvider.orderStatus.length == 0
                        ? 'Please Wait..'
                        : _notificationProvider.orderStatus[
                                _notificationProvider.orderStatus.length - 1]
                            .toString(),
                  ),
                ],
              ),
            ),
            Container(
              height: _height * 0.5,
              child: _notificationProvider.orderStatus.length == 0
                  ? _animations['Pending']
                  : _animations[_notificationProvider.orderStatus[
                      _notificationProvider.orderStatus.length - 1]],
            ),
            FlatButton(
              child: Text('Give Feedback'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FeedBacks()));
              },
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FlatButton(
              child: Text('Exit'),
              onPressed: () {
                exit(0);
              },
              color: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
