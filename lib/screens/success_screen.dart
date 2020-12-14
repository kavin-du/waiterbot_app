import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waiterbot_app/providers/final_orders_provider.dart';

class SuccessScreen extends StatelessWidget {
  final result; // do not remove

  SuccessScreen({this.result}); // do not remove
  @override
  Widget build(BuildContext context) {
    final _finalOrdersProvider = Provider.of<FinalOrdersProvider>(context);
    final _keys = _finalOrdersProvider.getOrders.keys.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Success'),
      ),
      body: Center(
        child: _keys.length == 0 ? Text('Orders empty') : ListView.builder(
          itemCount: _keys.length,
          itemBuilder: (context, index){
            return Container(
              height: 150,
              child: Column(
                children: [
                  Text(_finalOrdersProvider.getOrders[_keys[index]].name),
                  Text(_finalOrdersProvider.getOrders[_keys[index]].units.toString()),
                  Text(_finalOrdersProvider.getOrders[_keys[index]].selectedPortion),
                  Text('Total LKR'+(_finalOrdersProvider.getOrders[_keys[index]].portions[_finalOrdersProvider.getOrders[_keys[index]].selectedPortion]*_finalOrdersProvider.getOrders[_keys[index]].units).toString()),
                  FlatButton(
                    child: Text('delete order'), 
                    onPressed:(){
                      _finalOrdersProvider.removeOrder(_keys[index]);
                    }
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }



}