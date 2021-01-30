import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waiterbot_app/models/food_model.dart';
import 'package:waiterbot_app/providers/final_orders_provider.dart';

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
      decoration: BoxDecoration(
        color: Colors.blue[300],
        borderRadius: BorderRadius.circular(10)
      ),
      margin: const EdgeInsets.all(3),
      padding: const EdgeInsets.only(top: 4, bottom: 12),
      child: Column(
        children: [
          Text(
            widget.foodItem.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Image.network(
              //   widget.foodItem.image, 
              //   height: 100, 
              //   width: 100
              // ),
              CachedNetworkImage(
                width: 100,
                height: 100,
                imageUrl: widget.foodItem.image,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              Column(
                children: [
                  RatingStars(foodItem: widget.foodItem),
                  FlatButton(
                    child: Text('ADD TO LIST'),
                    onPressed: (){
                      FoodItem newfooditem = FoodItem.forFinalOrder(widget.foodItem, _count, widget.foodItem.portions[_portionIndex]['name']);
                      finalOrdersProvider.addOrder(newfooditem);
                    },
                    highlightColor: Colors.red,
                    color: Colors.yellow,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35))
                  ),
                ],
              ),
              Column(  
                children: [
                  Container(   
                    width: 100, 
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black)
                    ),               
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                      children: [
                        // buttons repetitive.................................................
                        FlatButton(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.all(0),
                          color: Colors.blue[600],                                                        
                          shape: CircleBorder(side: BorderSide()),
                          minWidth: 20,                            
                          child: Text('-', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),),
                          onPressed: (){
                            setState(() {
                              if(_count > 1) _count--;
                            });
                          },
                        ),
                        Container(width: 40, child: Center(child: Text(_count.toString()))),
                        FlatButton(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.all(0),
                          color: Colors.blue[600],                                                        
                          shape: CircleBorder(side: BorderSide()),
                          minWidth: 20,                            
                          child: Text('+', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),),
                          onPressed: (){
                            setState(() {
                              _count++;
                            });
                          },
                        ),
                      ],
                        // ),
                      ),
                  ),
                  Container(
                    width: 100,  
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black)
                    ),               
                    child: Row(   
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FlatButton(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.all(0),
                          color: Colors.blue[600],                                                        
                          shape: CircleBorder(side: BorderSide()),
                          minWidth: 20,                            
                          child: Text('<', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),),
                          onPressed: (){
                            if(_portionIndex > 0){
                              setState(() {
                                _portionIndex--;                                
                              });
                            }
                          },
                        ),
                        Container(width: 48, child: Center(child: Text(widget.foodItem.portions[_portionIndex]['name'].toString()))),
                        FlatButton(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.all(0),
                          color: Colors.blue[600],                                                        
                          shape: CircleBorder(side: BorderSide()),
                          minWidth: 20,                            
                          child: Text('>', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),),
                          onPressed: (){
                            if(_portionIndex < widget.foodItem.portions.length -1){
                              setState(() {
                                _portionIndex++;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Text('LKR '+(widget.foodItem.portions[_portionIndex]['price'] * _count).toString(), style: TextStyle(fontSize: 18),)
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}