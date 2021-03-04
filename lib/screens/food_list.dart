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
  String _pressedButton = '';
  int _categoryIndex = 0;
  int _currentFoodCard;
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
    print(_height); // * 22.5 + 17 
    // final _width = MediaQuery.of(context).size.width;
    final FoodListProvider _foodListProvider =
        Provider.of<FoodListProvider>(context);

    Widget shopInfo() {
      return Container(
        height: _height * 22.5 / 100,
        color: Colors.greenAccent,
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
                    SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        height: _height * 13.5 / 100,
                        imageUrl: data['imgUrl'],
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      data['name'],
                      style: TextStyle(fontFamily: 'Lobster', fontSize: 20),
                    ),
                    Text(
                      data['address'],
                      style: TextStyle(fontFamily: 'Lobster', fontSize: 15),
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
                  .map<FoodItem>((item) => FoodItem.fromJson(item)) // ! this is repetitive
                  .toList();

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
                // padding: const EdgeInsets.only(top: 10, bottom: 5),
                height: _height * 17 / 100,
                child: ListView.builder(
                  itemCount: _categories.length,
                  shrinkWrap: false,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        _foodListProvider.setFoodType = _categories[index];
                        setState(() {
                          _pressedButton = _categories[index];
                          _categoryIndex = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        padding: EdgeInsets.only(left: 5, right: 5),
                        // height: 150,
                        width: 100, // * height is controlled by main container
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: _categories[index] == _pressedButton
                              ? Constants.kPrimaryColor[300]
                              : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 12,
                              spreadRadius: 2,
                              offset: Offset(0.5, 0.5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              _categoryIcons[index],
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace stackTrace) {
                                return Image.asset(
                                    _categoryIcons[2]); // ! remove this one
                              },
                            ),
                            Text(
                              _categories[index],
                              style: TextStyle(
                                  color: _categories[index] == _pressedButton
                                      ? Colors.white
                                      : Constants.kPrimaryColor,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
              // return CarouselSlider(
              //   options: CarouselOptions(
              //       // aspectRatio: 1.0,
              //       enableInfiniteScroll: false,
              //       viewportFraction: 0.28, // 0.28
              //       height: 100,
              //       enlargeCenterPage: true,
              //       autoPlay: false,
              //       onPageChanged: (index, reason) {
              //         setState(() { // * try to use providers instead of setState
              //           _foodListProvider.setFoodType = categories[index];
              //           _pressedButton =
              //               categories[index]; // * not pressing anymore
              //           _categoryIndex = index;
              //         });
              //       }),
              //   items: categories
              //       .map(
              //         (item) => Container(
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(30),
              //             color: Colors.white,
              //             boxShadow: [
              //               BoxShadow(
              //                 color: Colors.grey,
              //                 blurRadius: 12,
              //                 spreadRadius: 2,
              //                 offset: Offset(0.5, 0.5),
              //               ),
              //             ]
              //           ),
              //           margin: const EdgeInsets.all(0),
              //           padding: EdgeInsets.only(left: 10, right: 10,),
              //           width: 100,
              //           constraints: BoxConstraints(
              //             minHeight: 100,
              //             minWidth: 100
              //           ),
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             children: [
              //               Image.asset(_category_icons[categories.indexOf(item)]),
              //               // Text(item),
              //             ],
              //           ),
              //         ),
              //       )
              //       .toList(),
              // );
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
      return FutureBuilder(
        future: _getShopFoods,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['success']) {
              List<Map<String, dynamic>> data =
                  List<Map<String, dynamic>>.from(snapshot.data['data']);
              List<FoodItem> foodItems = data
                  .map<FoodItem>((item) => FoodItem.fromJson(item))
                  .toList();
                  
              return Container(
                // width: 250, // ! relative ?
                height: _height * 50/100,
                child: CarouselSlider.builder(
                  unlimitedMode: true,
                  // controller: _sliderController,
                  slideBuilder: (index){
                     return foodItems[index].category ==
                            _foodListProvider.getFoodType
                        ? FoodCard(foodItem: foodItems[index])
                        : Container();
                  },
                  slideTransform: CubeTransform(),
                  slideIndicator: CircularSlideIndicator(
                    padding: EdgeInsets.only(bottom: 15),
                  ),
                  itemCount: 5,
                  initialPage: 0,
                  enableAutoSlider: true,
                ),
              );
              // return Container(
              //   width: 250, // ! relative ?
              //   height: _height * 50 /100,
              //   child: ListView.builder(
              //     itemCount: foodItems.length,
              //     itemBuilder: (context, index) {
              //       return foodItems[index].category ==
              //               _foodListProvider.getFoodType
              //           ? FoodCard(foodItem: foodItems[index])
              //           : Container();
              //     },
              //   ),
              // );
            } else {
              return LoadingBouncingGrid.circle(
                backgroundColor: Colors.blue,
              );
            }
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return LoadingBouncingGrid.circle(
            backgroundColor: Colors.blue,
          );
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
        child: Column(
          children: [
            shopInfo(),
            buttonBar(),
            foodCards(),
          ],
        ),
      ),
    );
  }
}
