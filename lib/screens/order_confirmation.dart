import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waiterbot_app/custom_widgets/final_order_card.dart';
import 'package:waiterbot_app/providers/final_orders_provider.dart';

class OrderConfirmation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final _finalOrdersProvider = Provider.of<FinalOrdersProvider>(context);

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
                onPressed: (){},
              ) : Container()
            ],
          )),
    );
  }
}
