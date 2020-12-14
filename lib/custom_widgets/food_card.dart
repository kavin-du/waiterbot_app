import 'package:flutter/material.dart';
import 'package:waiterbot_app/models/food_model.dart';

class FoodCard extends StatefulWidget {
  final FoodItem foodItem;
  int _count = 1;
  int _portionIndex = 0;
  FoodCard({Key key, @required this.foodItem}) : super(key: key);
  
  @override
  _FoodCardState createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(3),
      padding: const EdgeInsets.only(top: 4, bottom: 12),
      color: Colors.blue[300],
      child: Column(
        children: [
          Text(
            widget.foodItem.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('images/foods/chicken-fried-rice.jpg', height: 100),
              FlatButton(
                child: Text('ADD TO LIST '),
                onPressed: (){},
                color: Colors.yellow,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35))
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
                              if(widget._count > 1) widget._count--;
                            });
                          },
                        ),
                        Container(width: 40, child: Center(child: Text(widget._count.toString()))),
                        FlatButton(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.all(0),
                          color: Colors.blue[600],                                                        
                          shape: CircleBorder(side: BorderSide()),
                          minWidth: 20,                            
                          child: Text('+', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),),
                          onPressed: (){
                            setState(() {
                              widget._count++;
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
                            if(widget._portionIndex > 0){
                              setState(() {
                                widget._portionIndex--;                                
                              });
                            }
                          },
                        ),
                        Container(width: 40, child: Center(child: Text(widget.foodItem.portions.keys.toList()[widget._portionIndex].toString()))),
                        FlatButton(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.all(0),
                          color: Colors.blue[600],                                                        
                          shape: CircleBorder(side: BorderSide()),
                          minWidth: 20,                            
                          child: Text('>', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),),
                          onPressed: (){
                            if(widget._portionIndex < widget.foodItem.portions.keys.toList().length -1){
                              setState(() {
                                widget._portionIndex++;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Text('LKR '+(widget.foodItem.portions[widget.foodItem.portions.keys.toList()[widget._portionIndex]] * widget._count).toString(), style: TextStyle(fontSize: 18),)
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}