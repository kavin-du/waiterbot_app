import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:provider/provider.dart';
import 'package:waiterbot_app/custom_widgets/feedback_card.dart';
import 'package:waiterbot_app/custom_widgets/food_card.dart';
import 'package:waiterbot_app/models/food_model.dart';
import 'package:waiterbot_app/providers/final_orders_provider.dart';

class FeedBacks extends StatefulWidget {
  @override
  _FeedBacksState createState() => _FeedBacksState();
}

class _FeedBacksState extends State<FeedBacks> {
  CarouselSliderController _sliderController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    final FinalOrdersProvider _finalOrdersProvider =
        Provider.of<FinalOrdersProvider>(context);
    final List<FoodItem> _foodItems =
        _finalOrdersProvider.getOrders.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Feedbacks'),
      ),
      backgroundColor: Colors.lightGreenAccent,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 20),
            height: _height * 27 / 100,
            child: FlareActor(
              'animations/time-read-revisschool.flr',
              animation: 'read',
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: _height * 32.5 / 100,
            width: _width * 60 / 100,
            child: CarouselSlider.builder(
              unlimitedMode: true,
              controller: _sliderController,
              slideBuilder: (index) {
                return FeedbackCard(foodItem: _foodItems[index]);
              },
              slideTransform: DefaultTransform(),
              slideIndicator: CircularStaticIndicator(
                indicatorRadius: _height * 0.008136, // 6
                padding: EdgeInsets.only(bottom: _height * 2.15 / 100), // 20
                enableAnimation: true,
                currentIndicatorColor: Colors.white,
                // indicatorBackgroundColor: Colors.grey,
              ),
              itemCount: _foodItems.length,
              initialPage: 0,
            ),
          ),
        ],
      ),
    );
  }
}
