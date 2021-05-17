import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';
import 'package:provider/provider.dart';
import 'package:waiterbot_app/custom_widgets/final_order_card.dart';
import 'package:waiterbot_app/models/user_model.dart';
import 'package:waiterbot_app/providers/auth_provider.dart';
import 'package:waiterbot_app/providers/fetch_shop_items.dart';
import 'package:waiterbot_app/providers/final_orders_provider.dart';
import 'package:waiterbot_app/services/shared_preferences.dart';

import 'order_status.dart';

class OrderConfirmation extends StatelessWidget {

  void showAlert(BuildContext context, String title, String msg) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void startOneTimePayment(BuildContext context, String amount, User user) async {
    Map paymentObject = {
      "sandbox": true,
      "merchant_id": "1217300",
      "merchant_secret": "8Qg4JwFRF1U8LLokUzI8TI8LQyOuNFQJy4pDGIhR4iGY",
      "notify_url": "https://ent13zfovoz7d.x.pipedream.net/",
      "order_id": "ItemNo12345",
      "items": "Hello from Flutter!",
      "amount": amount,
      "currency": "LKR",
      "first_name": user.firstName,
      "last_name": user.lastName,
      "email": user.email,
      "phone": user.mobileNumber,
      "address": "No.1, Galle Road",
      "city": "Colombo",
      "country": "Sri Lanka",
      "delivery_address": "No. 46, Galle road, Kalutara South",
      "delivery_city": "Kalutara",
      "delivery_country": "Sri Lanka",
      "custom_1": "",
      "custom_2": ""
    };
    PayHere.startPayment(paymentObject, (paymentId) {
      print("One Time Payment Success. Payment Id: $paymentId");
      // showAlert(context, "Payment Success!", "Payment Id: $paymentId");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => OrderStatus(token: user.token)));
    }, (error) {
      print("One Time Payment Failed. Error: $error");
      showAlert(context, "Payment Failed", "$error");
    }, () {
      print("One Time Payment Dismissed");
      showAlert(context, "Payment Dismissed", "");
    });
  }

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
                            User user;
                            if (AuthProvider.guestLogin){
                              token = 'garbage';
                              user = User("xxxxx", "guest","guest", "guest@guest.com","0712345678",token);
                            } else await UserPreferences()
                                  .getUser()
                                  .then((u) => user = u);
                            startOneTimePayment(context, _finalOrdersProvider.getTotal.toString(), user);
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
