import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waiterbot_app/custom_widgets/final_order_card.dart';
import 'package:waiterbot_app/providers/fetch_shop_items.dart';
import 'package:waiterbot_app/providers/final_orders_provider.dart';
import 'package:waiterbot_app/screens/socket.dart';
import 'package:waiterbot_app/services/app_urls.dart';
import 'package:web_socket_channel/io.dart';

import 'order_status.dart';
import 'socket2.dart';
import 'socket3.dart';

class OrderConfirmation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final _finalOrdersProvider = Provider.of<FinalOrdersProvider>(context);
    final _fetchShopItems = Provider.of<FetchShopItems>(context, listen: false); 
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: Container(
          color: Colors.teal,
          // height: height*4/6,
          child: Column(
            children: [
              FinalOrderCard(),
              Container(
                margin: EdgeInsets.only(bottom: 15),
                child: Text(
                  'Net Total: LKR ' + _finalOrdersProvider.getTotal.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
              _finalOrdersProvider.getTotal > 0 ? FlatButton(
                padding: EdgeInsets.all(10),
                color: Colors.pink,
                child: Text(
                  'CONFIRM & PAY',
                  style: TextStyle(fontSize: 35, color: Colors.white),
                ),
                onPressed: () async {
                  // print(_finalOrdersProvider.getOrders.values.toList()[0].selectedPortion);
                  Map<String, dynamic> result;
                  await 
                    _fetchShopItems.placeOrder(_finalOrdersProvider.getOrders.values.toList(), _finalOrdersProvider.getTotal)
                    .then((value) => result = Map<String, dynamic>.from(value))
                    .whenComplete(() {
                      if(result['success']){
                        Navigator.push(
                          context,
                          // MaterialPageRoute(builder: (context) => OrderStatus()
                          // MaterialPageRoute(builder: (context) => Socket()
                          MaterialPageRoute(builder: (context) => Socket3(title: 'test title', channel: IOWebSocketChannel.connect('ws://echo.websocket.org'),)
                          )
                        );
                      } else {
                        Flushbar(
                          duration: Duration(seconds: 4),
                          title:"Hi",
                          message: Map<String, dynamic>.from(result)['message'],
                        ).show(context);
                      }
                    });
                },
              ) : Container()
            ],
          )),
    );
  }
}
