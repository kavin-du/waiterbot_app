import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waiterbot_app/providers/notification_provider.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final Size preferredSize;

  final String title;

  CustomAppBar({
    this.title,
    Key key,
  })  : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    var _notificationProvider = Provider.of<NotificationProvider>(context);
    
    return AppBar(
      backgroundColor: Colors.blue[300],
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          fontSize: _height * 0.02712,
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: new Stack(
            children: <Widget>[
              new Icon(Icons.notifications),
              _notificationProvider.notifyCount != 0
                  ? Positioned(
                      right: 0,
                      child: new Container(
                        padding: EdgeInsets.all(1),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: new Text(
                          _notificationProvider.notifyCount.toString(),
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
          onPressed: () async {
            _notificationProvider.onViewNotification();
            Navigator.pushNamed(context, "/notifications");
          },
        ),
        SizedBox(
          width: 15,
        )
      ],
    );
  }
}
