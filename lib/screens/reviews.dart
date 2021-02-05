import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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

  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final _fetchShopItems = FetchShopItems();

  Future<Map<String, dynamic>> getReviews() async {
    return await _fetchShopItems.fetchReviews(widget.foodItem.foodId);
  }

  @override
  void dispose() {
    super.dispose();
    _textController?.dispose();
    _formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget addReview() {
      return Container(
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
                            hintText: 'Add your review here'),
                        validator: (String text) {
                          return text.isEmpty ? 'Text is empty' : null;
                        },
                      ),
                    ),
                  ),
                  RatingBar.builder(
                    itemSize: 35,
                    initialRating: 1.0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 3),
                    itemBuilder: (context, _) {
                      return Icon(
                        Icons.star,
                        color: Colors.amber,
                      );
                    },
                    onRatingUpdate: (rating) {
                      _currentSliderValue = rating;
                    },
                  ),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    CircularProgressIndicator();
                    Map<String, dynamic> result;
                    await _fetchShopItems
                        .addReview(
                            widget.foodItem.foodId,
                            _textController.text.toString(),
                            _currentSliderValue.round())
                        .then((value) =>
                            result = Map<String, dynamic>.from(value))
                        .whenComplete(() {
                      setState(() {
                        Flushbar(
                          showProgressIndicator: true,
                          duration: Duration(seconds: 4),
                          title: "Hi",
                          message: result['message'].toString(),
                        ).show(context);
                      });
                    });
                  }
                  _textController.clear();
                },
                child: Text('Submit'))
          ],
        ),
      );
    }

    Widget showReviews() {
      return Container(
          child: FutureBuilder<Map<String, dynamic>>(
        future:
            getReviews(), // * not putting a reference bcz need to refresh every time when adding a comment
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['success']) {
              List<Map<String, dynamic>> reviews =
                  List<Map<String, dynamic>>.from(snapshot.data['data']);
              if (reviews.length == 0) {
                return Text('No reviews yet');
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Card(
                          color: Colors.blueAccent[100],
                          child: Text(
                            reviews[index]['comment'],
                            textAlign: TextAlign.center,
                          )),
                    );
                  },
                ),
              );
            } else {
              return Text(snapshot.data['message'].toString());
            }
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return CircularProgressIndicator(); // ! try to jumble this order
        },
      ));
    }

    Widget ingredients() {
      return Container(
        height: 100,
        color: Colors.greenAccent,
        alignment: Alignment.center,
        child: Text(widget.foodItem.ingredients.length == 0
            ? 'No ingredients yet'
            : widget.foodItem.ingredients.toString()),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Ratings & Reviews'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              ingredients(),
              addReview(),
              showReviews(),
            ],
          ),
        ));
  }
}
