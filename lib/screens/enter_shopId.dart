import 'package:flutter/material.dart';
import 'package:waiterbot_app/services/app_urls.dart';

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
              // print(_textController.text);
              AppUrls.setShopId = _textController.text;
              Navigator.pushNamed(context, '/foodList');
            }, 
            child: Text('Submit')
          )
        ],
      ),
    );
  }
}