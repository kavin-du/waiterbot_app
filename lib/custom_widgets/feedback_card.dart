import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waiterbot_app/models/food_model.dart';
import 'package:waiterbot_app/providers/final_orders_provider.dart';
import 'package:waiterbot_app/services/constants.dart';

import 'rating_starts.dart';

class FeedbackCard extends StatelessWidget {
  final FoodItem foodItem;

  const FeedbackCard({Key key, this.foodItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    // return Text(foodItem.name.toString());

    return Container(
      alignment: Alignment.center,
      height: _height * 0.349004, // 250, width controlled by parent widget
      decoration: BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 2,
            ),
          ]),
      margin: EdgeInsets.all(_height * 0.004068), // 3
      padding: EdgeInsets.all(_height * 0.02034), // 15
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // food image
          Container(
            width: _height * 13.5 / 100,
            height: _height * 13.5 / 100,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: this.foodItem.image,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          SizedBox(height: _height * 0.028476), // 21
          Text(
            foodItem.name,
            style: TextStyle(
              fontFamily: 'YanoneKaffeesatz',
              fontSize: _height * 0.032544, // 24
              color: Colors.white,
            ),
          ),
          RatingStars(foodItem: foodItem, addReviews: true,),
          SizedBox(height: _height * 0.00678), // 5
        ],
      ),
    );
  }
}
