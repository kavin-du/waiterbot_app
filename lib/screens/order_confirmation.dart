import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waiterbot_app/custom_widgets/final_order_card.dart';
import 'package:waiterbot_app/providers/auth_provider.dart';
import 'package:waiterbot_app/providers/fetch_shop_items.dart';
import 'package:waiterbot_app/providers/final_orders_provider.dart';
import 'package:waiterbot_app/services/shared_preferences.dart';

import 'order_status.dart';

class OrderConfirmation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final _finalOrdersProvider = Provider.of<FinalOrdersProvider>(context);
    final _fetchShopItems = Provider.of<FetchShopItems>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Orders',
          style: TextStyle(
            fontSize: height * 0.02712,
          ),
        ),
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
              _finalOrdersProvider.getTotal > 0
                  ? FlatButton(
                      padding: EdgeInsets.all(10),
                      color: Colors.pink,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        'CONFIRM & PAY',
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                      onPressed: () async {
                        // print(_finalOrdersProvider.getOrders.values.toList()[0].selectedPortion);
                        Map<String, dynamic> result;
                        await _fetchShopItems
                            .placeOrder(
                                _finalOrdersProvider.getOrders.values.toList(),
                                _finalOrdersProvider.getTotal)
                            .then((value) =>
                                result = Map<String, dynamic>.from(value))
                            .whenComplete(() async {
                          if (result['success']) {
                            String token;
                            if (AuthProvider.guestLogin) token = 'garbage';
                            else await UserPreferences()
                                  .getUser()
                                  .then((user) => token = user.token);
                            // String token = FetchShopItems.token;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        OrderStatus(token: token)));
                          } else {
                            Flushbar(
                              duration: Duration(seconds: 5),
                              title: "Hi",
                              message:
                                  Map<String, dynamic>.from(result)['message'],
                            ).show(context);
                          }
                        });
                      },
                    )
                  : Container()
            ],
          )),
    );
  }
}
