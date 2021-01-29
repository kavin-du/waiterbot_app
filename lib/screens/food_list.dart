import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waiterbot_app/custom_widgets/food_card.dart';
import 'package:waiterbot_app/models/food_model.dart';
import 'package:waiterbot_app/providers/fetch_shop_items.dart';
import 'package:waiterbot_app/providers/foodlist_provider.dart';
import 'package:waiterbot_app/screens/order_confirmation.dart';
import 'package:waiterbot_app/services/app_urls.dart';

class FoodList extends StatefulWidget {
  @override
  _FoodListState createState() => _FoodListState();
}

class _FoodListState extends State<FoodList> {
  String _pressedButton = '';  
  // Map<String, dynamic> _shopInfo;


  // final List<FoodItem> _foods = [
  //     FoodItem('Chicken Fried Rice', 'Fried Rice',{'Small': 350.0, 'Large': 450.0}), 
  //     FoodItem('Sea Food Rice', 'Fried Rice',{'Small': 450.0, 'Large': 550.0}), 
  //     FoodItem('Vegetable Rice & Curry', 'Rice & Curry',{'Small': 200.0, 'Large': 275.0}), 
  //     FoodItem('Mixed Fruit Juice', 'Drinks',{'Small': 120.0, 'Large': 200.0}), 
  // ];

  // List<FoodItem> _foods;
  // List<String> _foodTypes;

  @override
  Widget build(BuildContext context) {
    
    
    final FoodListProvider _foodListProvider = Provider.of<FoodListProvider>(context);
    final FetchShopItems _fetchShopItems = Provider.of<FetchShopItems>(context, listen: false);


    Future<Map<String, dynamic>> getShopItems() async {
      return _fetchShopItems.fetchShopInfo(AppUrls.getShopId)
        .then((result) => result['data']);
    }
    // ! still sending several reqs when building interface

    Future<List<FoodItem>> getShopFoods() async {
      return _fetchShopItems.fetchFoods()
        .then((Map<String, dynamic> value) {
          List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(value['data']);
          List<FoodItem> foodItems = data
            .map<FoodItem>((item) => FoodItem.fromJson(item)).toList();
            // .map<FoodItem>((item) => FoodItem(item['name'], item['category'], List<Map<String, dynamic>>.from(item['portions']), item['imgUrl'])).toList();
          return foodItems;
        });
    }


    Widget foodCards(List<FoodItem> foods){
      if(_foodListProvider.getFoodType == 'All'){
        return Expanded(
          child: ListView.builder(
            itemCount: foods.length,
            itemBuilder: (context, index){
              return FoodCard(foodItem: foods[index]);
            },
          ),
        );
      }
      return Expanded(
        child: ListView.builder(
          itemCount: foods.length,
          itemBuilder: (context, index){
            return foods[index].category == _foodListProvider.getFoodType ? FoodCard(foodItem: foods[index]) : Container();
          },
        ),
      );
    }

    Widget buttonBarAndFoodCards() {
      return FutureBuilder<List<FoodItem>>(
        future: getShopFoods(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            
            List<String> categories = ['All'] + snapshot.data.map((item) => item.category).toSet().toList();
            return Expanded(
              child: Column(
                children: [
                  Container( 
                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                    height: 50,
                    child: ListView.builder(
                        itemCount: categories.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return FlatButton(
                            child: Text(categories[index]),
                            color: categories[index] == _pressedButton ? Colors.green : null,
                            onPressed: () {
                              _foodListProvider.setFoodType = categories[index];
                              setState(() {
                                _pressedButton = categories[index];
                              });                  
                            },
                          );
                        }),
                  ),
                  foodCards(snapshot.data)
                ],
              ),
            ); 
          } else if(snapshot.hasError){
            print(snapshot.error.toString());
            return Text(snapshot.error.toString());
          }
          return CircularProgressIndicator();
        },
      );
      
    }


    // return Builder(
    //   builder: (BuildContext context){
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
                    child: FutureBuilder<Map<String, dynamic>>(
                      future: getShopItems(),
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          return Column(
                            children: [
                              SizedBox(height: 15),
                              Image.network(
                                snapshot.data['imgUrl'], //'images/red_cafe.png',
                                height: 100,
                              ),
                              SizedBox(height: 15),
                              Text(snapshot.data['name']),
                              Text(snapshot.data['address']),
                            ],
                          );
                        } else if (snapshot.hasError){
                          return Text(snapshot.error);
                        }
                        return CircularProgressIndicator();
                      },
                    )
                ),
              ),
              // _fetchShopItems.fetchStatus == Status.Fetching ? CircularProgressIndicator() : buttonBar(),
              // _fetchShopItems.fetchStatus == Status.Fetching ? CircularProgressIndicator() : foodCards()
              buttonBarAndFoodCards(),
              // foodCards(),
            ]),
          ),
        );
    //   }
    // );
  }
}
