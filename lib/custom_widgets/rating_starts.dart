import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final int value;

  const RatingStars({Key key, this.value}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.pink[50],
        onTap: (){},
        child: Row(
          children: List.generate(5, (index) {
            return Icon(index < value ? Icons.star : Icons.star_outline);
          }),
        ),
      ),
    );
  }
}