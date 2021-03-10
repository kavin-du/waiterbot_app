import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waiterbot_app/providers/final_orders_provider.dart';

// cards shown in the payment page

class FinalOrderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final _finalOrdersProvider = Provider.of<FinalOrdersProvider>(context);
    final _keys = _finalOrdersProvider.getOrders.keys.toList();
    TextStyle textStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500
    );
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 5, bottom: 5),
      padding: EdgeInsets.only(left: 10, right: 10),
      height: height*4/6,
      child: _keys.length == 0 ? Text('Orders empty') : ListView.builder(
        itemCount: _keys.length,
        itemBuilder: (context, index){
          return Container(
            height: 100,
            margin: EdgeInsets.only(top: 5, bottom: 5),
            padding: EdgeInsets.only(left: 15, right: 10),
            color: Colors.amberAccent,
            child: Row(              
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_finalOrdersProvider.getOrders[_keys[index]].name, style: textStyle),
                    Text('Amount: '+_finalOrdersProvider.getOrders[_keys[index]].units.toString(), style: textStyle),
                    Text('Size: '+_finalOrdersProvider.getOrders[_keys[index]].selectedPortion, style: textStyle),
                    Text('Total: LKR '+(_finalOrdersProvider.getOrders[_keys[index]].portions.firstWhere((element) => element['name'] == _finalOrdersProvider.getOrders[_keys[index]].selectedPortion)['price']*
                    _finalOrdersProvider.getOrders[_keys[index]].units).toString(), style: textStyle),
                  ],
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  color: Colors.redAccent,
                  child: Text('Remove'), 
                  onPressed:(){
                    _finalOrdersProvider.removeOrder(_keys[index]);
                  }
                )
              ],
            )
          );
        },
      ),
    );
  }
}