import 'package:flutter/material.dart';

class EnterShopId extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _textController = new TextEditingController();
    // ! dispose the controller

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(25),
            child: TextField(     
              controller: _textController,       
              decoration: InputDecoration(
                hintText: 'Enter shop ID'
              )
            ),
          ),
          ElevatedButton(
            onPressed: (){
              print(_textController.text);
            }, 
            child: Text('Submit')
          )
        ],
      ),
    );
  }
}