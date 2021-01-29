import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waiterbot_app/models/food_model.dart';
import 'package:waiterbot_app/providers/fetch_shop_items.dart';

class Reviews extends StatefulWidget {
  final FoodItem foodItem;

  const Reviews({Key key, this.foodItem}) : super(key: key);

  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  double _currentSliderValue = 1;

  @override
  Widget build(BuildContext context) {
    FetchShopItems _fetchShopItems = Provider.of<FetchShopItems>(context, listen: false);

    final _textController = TextEditingController(); // ! dispose the controller
    final _formKey = GlobalKey<FormState>();


    Future<Map<String, dynamic>> getReviews() async {
      return await _fetchShopItems.fetchReviews(widget.foodItem.foodId)
      .then((value) {
        return value;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Ratings & Reviews'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container( // * ingredients
              height: 100,
              color: Colors.greenAccent,
              alignment: Alignment.center,
              child: Text(widget.foodItem.ingredients.length == 0 ? 'No ingredients yet' : widget.foodItem.ingredients.toString()),
            ),
            Container( // * add review
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(5),
              alignment: Alignment.center,
              height: 135,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: 250,
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: _textController,
                              decoration: InputDecoration(
                                icon: Icon(Icons.rate_review_sharp),
                                hintText: 'Add your review here'
                              ),
                              validator: (String text){
                                return text.isEmpty ? 'Text is empty': null;
                              },
                            ),
                          ),
                        ),
                        Slider(
                          value: _currentSliderValue,
                          divisions: 4,
                          min: 1,
                          max: 5,
                          label: _currentSliderValue.round().toString(),
                          onChanged: (double value){
                            setState(() {
                              _currentSliderValue = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if(_formKey.currentState.validate()){
                        Map<String, dynamic> result;
                        await
                            _fetchShopItems.addReview(widget.foodItem.foodId, _textController.text.toString(), _currentSliderValue.round())
                            .then((value) => result = Map<String, dynamic>.from(value))
                            .whenComplete((){
                              // print(Map<String, dynamic>.from(result)['message']);
                              setState(() {
                                Flushbar(
                                  duration: Duration(seconds: 4),
                                  title:"Hi",
                                  message: Map<String, dynamic>.from(result)['message'],
                                ).show(context);
                              });
                            });
                      } else {
                        print('error happened');
                      }
                    }, 
                    child: Text('Submit')
                  )
                ],
              ),
            ),
            Container( // * get reviews
              // alignment: Alignment.center,
              child: FutureBuilder<Map<String, dynamic>>(
                future: getReviews(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    if(snapshot.data['success']){
                      List<Map<String, dynamic>> reviews = List<Map<String, dynamic>>.from(snapshot.data['data']);
                      // print(reviews.length);
                      if(reviews.length == 0){
                        return Text('No reviews yet');
                      }
                      return Expanded(
                        child: ListView.builder(
                          itemCount: reviews.length,
                          itemBuilder: (context, index){
                            return Container(
                              child: Card(
                                color: Colors.blueAccent[100],
                                child: Text(
                                  reviews[index]['comment'],
                                  textAlign: TextAlign.center,
                                )
                              ),
                            );
                          },

                        ),
                      );
                    } else {
                      return Text(snapshot.data['message']);
                    }
                  } else if(snapshot.hasError){
                    return Text(snapshot.error.toString());
                  }
                  return CircularProgressIndicator();  // ! try to jumble this order
                },
              )
            ),
          ],
        ),
      )
    );
  }
}