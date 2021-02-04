import 'package:cached_network_image/cached_network_image.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waiterbot_app/custom_widgets/custom_appbar.dart';
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
  Future<Map<String, dynamic>> _getShopItems;
  Future<Map<String, dynamic>> _getShopFoods;

  Future<Map<String, dynamic>> getShopItems() async {
    return await FetchShopItems().fetchShopInfo();
  }

  Future<Map<String, dynamic>> getShopFoods() async {
    return await FetchShopItems().fetchFoods();
    // return FetchShopItems().fetchFoods().then((Map<String, dynamic> value) {
    //   List<Map<String, dynamic>> data =
    //       List<Map<String, dynamic>>.from(value['data']);
    //   List<FoodItem> foodItems =
    //       data.map<FoodItem>((item) => FoodItem.fromJson(item)).toList();
    //   return foodItems;
    // });
  }

  @override
  void initState() {
    super.initState();
    _getShopItems = getShopItems();
    _getShopFoods = getShopFoods();
  }

  @override
  Widget build(BuildContext context) {
    final FoodListProvider _foodListProvider =
        Provider.of<FoodListProvider>(context);

    Widget shopInfo() {
      return Container(
        height: 200,
        color: Colors.greenAccent,
        child: Center(
            child: FutureBuilder<Map<String, dynamic>>(
          future: _getShopItems,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if(snapshot.data['success']){
                Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.data['data']);
                return Column(
                  children: [
                    SizedBox(height: 15),
                    CachedNetworkImage(
                      height: 100,
                      imageUrl: data['imgUrl'],
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    SizedBox(height: 15),
                    Text(data['name']),
                    Text(data['address']),
                  ],
                );
              } else {
                return Text(snapshot.data['message'].toString());
              }              
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return CircularProgressIndicator();
          },
        )),
      );
    }

    Widget foodCards() { // ! do not return text widget, this is a list view
      return FutureBuilder(
        future: _getShopFoods,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if(snapshot.data['success']){
              List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(snapshot.data['data']);
              List<FoodItem> foodItems = data.map<FoodItem>((item) => FoodItem.fromJson(item)).toList();

              if (_foodListProvider.getFoodType == 'All') {
                return Expanded(
                  child: ListView.builder(
                    itemCount: foodItems.length,
                    itemBuilder: (context, index) {
                      return FoodCard(foodItem: foodItems[index]);
                    },
                  ),
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: foodItems.length,
                  itemBuilder: (context, index) {
                    return foodItems[index].category ==
                            _foodListProvider.getFoodType
                        ? FoodCard(foodItem: foodItems[index])
                        : Container();
                  },
                ),
              );
            } else {
              return CircularProgressIndicator(); // otherwise all errors are text widgets
              // return Text(snapshot.data['message'].toString());
            }
            
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return CircularProgressIndicator();
        },
      );
    }

    Widget buttonBar() {
      return FutureBuilder(
        future: _getShopFoods,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if(snapshot.data['success']){              
              List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(snapshot.data['data']);
              List<FoodItem> foodItems = data.map<FoodItem>((item) => FoodItem.fromJson(item)).toList();

              List<String> categories = ['All'] +
                foodItems.map((item) => item.category).toSet().toList();
              return Container(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                height: 50,
                child: ListView.builder(
                    itemCount: categories.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return FlatButton(
                        child: Text(categories[index]),
                        color: categories[index] == _pressedButton
                            ? Colors.green
                            : null,
                        onPressed: () {
                          _foodListProvider.setFoodType = categories[index];
                          setState(() {
                            _pressedButton = categories[index];
                          });
                        },
                      );
                    }),
              );
            } else {
              return Container(height: 20);
              // return CircularProgressIndicator(); // otherwise all errors are text widgets
              // return Text(snapshot.data['message'].toString());
            }
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return CircularProgressIndicator();
        },
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Welcome',
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton(
          child: Image.asset('images/floating-button.png'),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => OrderConfirmation()));
          },
          tooltip: 'Check your orders & Purchase',
        ),
      ),
      body: SafeArea(
        child: Column(children: [
          shopInfo(),
          buttonBar(),
          foodCards(),
        ]),
      ),
    );
  }
}
