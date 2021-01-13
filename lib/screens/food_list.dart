import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waiterbot_app/custom_widgets/food_card.dart';
import 'package:waiterbot_app/models/food_model.dart';
import 'package:waiterbot_app/providers/foodlist_provider.dart';
import 'package:waiterbot_app/screens/order_confirmation.dart';

import 'success_screen.dart';

class FoodList extends StatefulWidget {
  @override
  _FoodListState createState() => _FoodListState();
}

class _FoodListState extends State<FoodList> {
  String _pressedButton = '';
  

  final List<FoodItem> _foods = [
      FoodItem('Chicken Fried Rice', 'Fried Rice',{'Small': 350.0, 'Large': 450.0}), 
      FoodItem('Sea Food Rice', 'Fried Rice',{'Small': 450.0, 'Large': 550.0}), 
      FoodItem('Vegetable Rice & Curry', 'Rice & Curry',{'Small': 200.0, 'Large': 275.0}), 
      FoodItem('Mixed Fruit Juice', 'Drinks',{'Small': 120.0, 'Large': 200.0}), 
  ];

  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.of(context).size.height;

    // these things build again when build method called ?
    final FoodListProvider _foodListProvider = Provider.of<FoodListProvider>(context);

    final List<String> _foodTypes = ['All'] + _foods.map((item) => item.category).toSet().toList();// not sure final when updating
    
    Widget foodCards(){
      if(_foodListProvider.getFoodType == 'All'){
        return Expanded(
          child: ListView.builder(
            itemCount: _foods.length,
            itemBuilder: (context, index){
              return FoodCard(foodItem: _foods[index]);
            },
          ),
        );
      }
      return Expanded(
        child: ListView.builder(
          itemCount: _foods.length,
          itemBuilder: (context, index){
            return _foods[index].category == _foodListProvider.getFoodType ? FoodCard(foodItem: _foods[index]) : Container();
          },
        ),
      );
    }

    Widget buttonBar() {
      return Container( 
        padding: const EdgeInsets.only(top: 10, bottom: 5),
        height: 50,
        child: ListView.builder(
            itemCount: _foodTypes.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return FlatButton(
                child: Text(_foodTypes[index]),
                color: _foodTypes[index] == _pressedButton ? Colors.green : null,
                onPressed: () {
                  _foodListProvider.setFoodType = _foodTypes[index];
                  setState(() {
                    _pressedButton = _foodTypes[index];
                  });                  
                },
              );
            }),
      );
    }


    return Builder(
      builder: (BuildContext context){
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Image.asset('images/floating-button.png'),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderConfirmation()));
            },
            tooltip: 'Check your orders & Purchase',
          ),
          body: SafeArea(
            child: Column(children: [
              Container(
                height: 200,
                color: Colors.greenAccent,
                child: Center(
                    child: Column(
                  children: [
                    SizedBox(height: 15),
                    Image.asset(
                      'images/red_cafe.png',
                      height: 100,
                    ),
                    SizedBox(height: 15),
                    Text('The Red Cafe Restaurant'),
                    Text('Colombo Road, Peradeniya'),
                  ],
                )),
              ),
              buttonBar(),
              foodCards()
            ]),
          ),
        );
      }
    );
  }
}
