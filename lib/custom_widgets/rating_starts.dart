import 'package:flutter/material.dart';
import 'package:waiterbot_app/models/food_model.dart';
import 'package:waiterbot_app/screens/reviews.dart';

class RatingStars extends StatelessWidget {
  // final int value;
  final FoodItem foodItem;

  const RatingStars({Key key, this.foodItem}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    int value = foodItem.stars == 0 ? 0 : (foodItem.stars/foodItem.reviewCount).round();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.pink[50],
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => Reviews(foodItem: foodItem)));
        },
        child: Row(
          children: List.generate(5, (index) {
            return Icon(index < value ? Icons.star : Icons.star_outline);
          }),
        ),
      ),
    );
  }
}