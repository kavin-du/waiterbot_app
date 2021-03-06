import 'package:cached_network_image/cached_network_image.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';
import 'package:waiterbot_app/custom_widgets/custom_appbar.dart';
import 'package:waiterbot_app/custom_widgets/food_card.dart';
import 'package:waiterbot_app/models/food_model.dart';
import 'package:waiterbot_app/providers/fetch_shop_items.dart';
import 'package:waiterbot_app/providers/foodlist_provider.dart';
import 'package:waiterbot_app/screens/order_confirmation.dart';
import 'package:waiterbot_app/services/app_urls.dart';
import 'package:waiterbot_app/services/constants.dart';

class FoodList extends StatefulWidget {
  @override
  _FoodListState createState() => _FoodListState();
}

class _FoodListState extends State<FoodList> {
  // String _pressedButton = '';
  // int _categoryIndex = 0;
  // int _currentFoodCard;
  Future<Map<String, dynamic>> _getShopItems;
  Future<Map<String, dynamic>> _getShopFoods;
  CarouselSliderController _sliderController;

  Future<Map<String, dynamic>> getShopItems() async {
    return await FetchShopItems().fetchShopInfo();
  }

  Future<Map<String, dynamic>> getShopFoods() async {
    return await FetchShopItems().fetchFoods();
  }

  @override
  void initState() {
    super.initState();
    _getShopItems = getShopItems();
    _getShopFoods = getShopFoods();
    _sliderController = CarouselSliderController();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    // print(_height); // * 22.5 + 17     737.454 total
    final _width = MediaQuery.of(context).size.width;
    // print(_width); // 392.727
    final FoodListProvider _foodListProvider =
        Provider.of<FoodListProvider>(context);

    Widget shopInfo() {
      return Container(
        height: _height * 22.5 / 100,
        color: Colors.transparent,
        child: Center(
            child: FutureBuilder<Map<String, dynamic>>(
          future: _getShopItems,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data['success']) {
                Map<String, dynamic> data =
                    Map<String, dynamic>.from(snapshot.data['data']);
                return Column(
                  children: [
                    SizedBox(height: _height * 1.3568/100),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 3,
                            blurRadius: 5,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          height: _height * 13.5 / 100,
                          imageUrl: data['imgUrl'],
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                    ),
                    SizedBox(height: _height * 0.678/100),
                    Text(
                      data['name'],
                      style: TextStyle(fontFamily: 'Lobster', fontSize: _height * 2.712/100),
                    ),
                    Text(
                      data['address'],
                      style: TextStyle(fontFamily: 'Lobster', fontSize: _height * 2.034/100),
                    ),
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

    Widget buttonBar() {
      return FutureBuilder(
        future: _getShopFoods,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['success']) {
              List<Map<String, dynamic>> _data =
                  List<Map<String, dynamic>>.from(snapshot.data['data']);
              List<FoodItem> _foodItems = _data
                  .map<FoodItem>((item) => FoodItem.fromJson(item))
                  .toList();

              _foodListProvider.setFoodList = _foodItems;

              List<String> _categories = _foodItems
                  .map((item) => item.category)
                  .toSet()
                  .toList(); // * this is mapping again as a list, duplicate

              List<String> _categoryIcons = [
                'images/food_categories/rice.png',
                'images/food_categories/noodles.png',
                'images/food_categories/soup.jpg',
                'images/food_categories/soup.jpg',
              ];
              return Container(
                padding: EdgeInsets.only(left: _height * 0.678/100, right: _height * 0.678/100), // 5
                color: Colors.transparent,
                height: _height * 18 / 100, // 18%
                child: ListView.builder(
                  itemCount: _categories.length,
                  shrinkWrap: false,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        _foodListProvider.setFoodType = _categories[index];
                        // setState(() {
                        //   _pressedButton = _categories[index];
                        //   _categoryIndex = index;
                        // });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: _height * 1.22/100, bottom: _height * 1.22/100, left: _height * 0.8136/100, right: _height * 0.8136/100), // 9 9 6 6
                        padding: EdgeInsets.only(left: _height * 0.678/100, right: _height * 0.678/100), // 5
                        width: _width *25.4629 /100, // * height is controlled by main container, 100
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: _categories[index] ==
                                  _foodListProvider.getFoodType
                              ? Constants.kPrimaryColor[300]
                              : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 7,
                              spreadRadius: 2,
                              offset: Offset(0.5, 0.5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(_categoryIcons[index], height: _height * 0.10848,), // 80
                            Text(
                              _categories[index],
                              style: TextStyle(
                                  color: _categories[index] ==
                                          _foodListProvider.getFoodType
                                      ? Colors.white
                                      : Constants.kPrimaryColor,
                                  fontSize: _height * 2.169/100,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return Container(height: 20);
            }
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Container(height: 20);
        },
      );
    }

    Widget foodCards() {
      String _category = _foodListProvider.getFoodType;
      if (_category.isEmpty) return Container();

      List<FoodItem> _foodItems = _foodListProvider.getFoodList(_category);
      return Container(
        height: _height * 45.5 / 100,
        width: _width * 60 / 100,
        child: CarouselSlider.builder(
          unlimitedMode: true,
          controller: _sliderController,
          slideBuilder: (index) {
            return FoodCard(foodItem: _foodItems[index]);
          },
          slideTransform: DefaultTransform(),
          slideIndicator: CircularStaticIndicator(
            indicatorRadius: _height * 0.008136, // 6
            padding: EdgeInsets.only(bottom: _height * 2.15/100), // 20
            enableAnimation: true,
            currentIndicatorColor: Colors.white,
            // indicatorBackgroundColor: Colors.grey,
          ),
          itemCount: _foodItems.length,
          initialPage: 0,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        // color: Colors.redAccent,
        image: DecorationImage(
          image: AssetImage('images/temp.jpg'),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
      appBar: CustomAppBar(
        title: 'Welcome to WaiterBot !',
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: _height * 9.492/100), // 70
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
        child: Column(
          children: [
            shopInfo(),
            buttonBar(),
            foodCards(),
          ],
        ),
      ),
      ),
    );
  }
}
