import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waiterbot_app/models/food_model.dart';
import 'package:waiterbot_app/providers/final_orders_provider.dart';
import 'package:waiterbot_app/services/constants.dart';

import 'rating_starts.dart';

class FoodCard extends StatefulWidget {
  final FoodItem foodItem;
  FoodCard({Key key, @required this.foodItem}) : super(key: key);

  @override
  _FoodCardState createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  int _count = 1;
  int _portionIndex = 0;

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    final finalOrdersProvider = Provider.of<FinalOrdersProvider>(context);
    return Container(
      padding: EdgeInsets.only(top: _height * 0.00678), // 5
      child: Stack(
        children: [
          Positioned(
            top: _height * 0.089497, // 66
            child: Container(
              height: _height * 0.349004, // 250, width controlled by parent widget 
              decoration: BoxDecoration(
                color: Constants.kPrimaryColor,
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 1,
                    blurRadius: 2,
                  ),
                ]
              ),
              margin: EdgeInsets.all(_height * 0.004068), // 3
              padding: EdgeInsets.all(_height * 0.02034), // 15
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: _height * 0.028476), // 21
                  Text(
                    widget.foodItem.name,
                    style: TextStyle(
                        fontFamily: 'YanoneKaffeesatz',
                        fontSize: _height * 0.032544, // 24
                        color: Colors.white,
                    ),
                  ),
                  RatingStars(foodItem: widget.foodItem),
                  SizedBox(height: _height * 0.00678), // 5
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Rs.' +
                            (widget.foodItem.portions[_portionIndex]['price'] *
                                    _count)
                                .toString(),
                        style: TextStyle(
                          fontSize: _height * 0.02712, //20
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Column(
                        children: [
                          // portion count
                          Container(
                            height: _height * 0.05424, // 40
                            width: _width * 0.318287, // 125
                            margin: EdgeInsets.all(_height * 0.00339), // 2.5
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white, width: _height * 0.002712), // 2
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FlatButton(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding: const EdgeInsets.all(0),
                                  minWidth: _width * 0.050925, // 20
                                  child: Text(
                                    '-',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: _height * 0.0339, // 25
                                        color: Colors.white),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (_count > 1) _count--;
                                    });
                                  },
                                ),
                                Container(
                                  width: _width * 0.165509, // 65
                                  child: Center(
                                    child: Text(
                                      _count.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                FlatButton(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding: const EdgeInsets.all(0),
                                  minWidth: _width * 0.050925, // 20
                                  child: Text(
                                    '+',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: _height * 0.02712, // 20
                                        color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _count++;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          // portion type
                          Container(
                            margin: EdgeInsets.all(_height * 0.00339), // 2.5
                            height: _height * 0.05424, // 40
                            width: _width * 0.318287, // 125
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white, width: _height * 0.002712), // 2
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FlatButton(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding: const EdgeInsets.all(0),
                                  minWidth: _width * 0.050925, // 20
                                  child: Text(
                                    '-',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: _height * 0.0339, // 25
                                        color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_portionIndex > 0) {
                                      setState(() {
                                        _portionIndex--;
                                      });
                                    }
                                  },
                                ),
                                Container(
                                  width: _width * 0.165509, // 65
                                  child: Center(
                                    child: Text(
                                      widget.foodItem
                                          .portions[_portionIndex]['name']
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                FlatButton(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding: const EdgeInsets.all(0),
                                  minWidth: _width * 0.050925, // 20
                                  child: Text(
                                    '+',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: _height * 0.02712, // 20
                                        color: Colors.white),
                                  ),
                                  onPressed: () {
                                    if (_portionIndex <
                                        widget.foodItem.portions.length - 1) {
                                      setState(() {
                                        _portionIndex++;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  FlatButton(
                    height: _height * 0.04881, // 36
                    child: Text('ADD TO LIST', style: TextStyle(color: Constants.kPrimaryColor,)),
                    onPressed: () {
                      FoodItem newfooditem = FoodItem.forFinalOrder(
                          widget.foodItem,
                          _count,
                          widget.foodItem.portions[_portionIndex]['name']);
                      finalOrdersProvider.addOrder(newfooditem);
                    },
                    highlightColor: Colors.red,
                    color: Colors.yellow,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // food image
          Positioned(
            top: 2,
            left: 65,
            child: Container(
              width: _height * 13.5 / 100,
              height: _height * 13.5 / 100,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Constants.kPrimaryColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: widget.foodItem.image,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
