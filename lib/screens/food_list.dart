import 'package:cached_network_image/cached_network_image.dart';
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
  Future<List<FoodItem>> _getShopFoods;

  Future<Map<String, dynamic>> getShopItems() async {
    return FetchShopItems()
        .fetchShopInfo(AppUrls.getShopId)
        .then((result) => result['data']);
  }

  Future<List<FoodItem>> getShopFoods() async {
    return FetchShopItems().fetchFoods().then((Map<String, dynamic> value) {
      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(value['data']);
      List<FoodItem> foodItems =
          data.map<FoodItem>((item) => FoodItem.fromJson(item)).toList();
      return foodItems;
    });
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
              return Column(
                children: [
                  SizedBox(height: 15),
                  CachedNetworkImage(
                    height: 100,
                    imageUrl: snapshot.data['imgUrl'],
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  SizedBox(height: 15),
                  Text(snapshot.data['name']),
                  Text(snapshot.data['address']),
                ],
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error);
            }
            return CircularProgressIndicator();
          },
        )),
      );
    }

    Widget foodCards() {
      return FutureBuilder(
        future: _getShopFoods,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (_foodListProvider.getFoodType == 'All') {
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return FoodCard(foodItem: snapshot.data[index]);
                  },
                ),
              );
            }
            return Expanded(
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return snapshot.data[index].category ==
                          _foodListProvider.getFoodType
                      ? FoodCard(foodItem: snapshot.data[index])
                      : Container();
                },
              ),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Text(snapshot.error.toString());
          }
          return CircularProgressIndicator();
        },
      );
    }

    Widget buttonBar() {
      return FutureBuilder<List<FoodItem>>(
        future: _getShopFoods,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String> categories = ['All'] +
                snapshot.data.map((item) => item.category).toSet().toList();
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
          } else if (snapshot.hasError) {
            print(snapshot.error.toString());
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
