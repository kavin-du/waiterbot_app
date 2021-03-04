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
    final finalOrdersProvider = Provider.of<FinalOrdersProvider>(context);

    return Container(
      height: 320, // width controlled by parent widget // ! make this relative height
      decoration: BoxDecoration(
          color: Constants.kPrimaryColor,
          borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(3),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            // food image
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 100,
              height: 100,
              child: FittedBox(
                fit: BoxFit.cover,
                child: CachedNetworkImage(
                  imageUrl: widget.foodItem.image,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          ),
          Text(
            widget.foodItem.name,
            style: TextStyle(
                fontWeight: FontWeight.normal, fontSize: 20, color: Colors.white),
          ),
          RatingStars(foodItem: widget.foodItem),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Rs.' +
                    (widget.foodItem.portions[_portionIndex]['price'] * _count)
                        .toString(),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                children: [
                  // portion count
                  Container(
                    width: 125,
                    margin: EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 2),),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FlatButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.all(0),
                          minWidth: 20,
                          child: Text(
                            '-',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Colors.white),
                          ),
                          onPressed: () {
                            setState(() {
                              if (_count > 1) _count--;
                            });
                          },
                        ),
                        Container(
                          width: 65,
                          child: Center(
                            child: Text(_count.toString(), style: TextStyle(color: Colors.white,),),
                          ),
                        ),
                        FlatButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.all(0),
                          // color: Colors.blue[600],
                          // shape: CircleBorder(side: BorderSide()),
                          minWidth: 20,
                          child: Text(
                            '+',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
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
                    margin: EdgeInsets.all(2.5),
                    width: 125,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 2),),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FlatButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.all(0),
                          minWidth: 20,
                          child: Text(
                            '-',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Colors.white),
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
                          width: 65,
                          child: Center(
                            child: Text(widget
                                .foodItem.portions[_portionIndex]['name']
                                .toString(), style: TextStyle(color: Colors.white,),),
                          ),
                        ),
                        FlatButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.all(0),
                          minWidth: 20,
                          child: Text(
                            '+',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
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
              child: Text('ADD TO LIST'),
              onPressed: () {
                FoodItem newfooditem = FoodItem.forFinalOrder(widget.foodItem,
                    _count, widget.foodItem.portions[_portionIndex]['name']);
                finalOrdersProvider.addOrder(newfooditem);
              },
              highlightColor: Colors.red,
              color: Colors.yellow,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35))),
        ],
      ),
    );
  }
}
