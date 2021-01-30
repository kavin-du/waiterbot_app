import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:waiterbot_app/providers/fetch_shop_items.dart';
import 'package:waiterbot_app/services/app_urls.dart';
import 'package:waiterbot_app/services/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'dart:async';


// STEP1:  Stream setup
class StreamSocket{
  final _socketResponse= StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose(){
    _socketResponse.close();
  }
}

class OrderStatus extends StatefulWidget {
  // final WebSocketChannel channel = IOWebSocketChannel.connect(AppUrls.websocketUrl, 
  //   headers: {
  //     "Authorization": "Bearer ${FetchShopItems.token}",
  //     "Connection": "upgrade",
  //     "Upgrade": "websocket"
  // });
  
  final StreamSocket streamSocket =StreamSocket();

  @override
  _OrderStatusState createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {


  @override
  void initState() {
    super.initState();
    connectAndListen();
    // widget.channel.sink.add(jsonEncode(message));
    // widget.channel.sink.add("sfsdfdsfsf");
  }

  @override
  void dispose() {
    super.dispose();
    // widget.channel.sink.close();
  }

  //STEP2: Add this function in main function in main.dart file and add incoming data to the stream
void connectAndListen(){
  IO.Socket socket = IO.io(AppUrls.websocketUrl,
      OptionBuilder()
       .setTransports(['websocket'])
       .disableAutoConnect()
       .setExtraHeaders({"auth": "Bearer ${FetchShopItems.token}"})
       .build());
    socket.connect();
    socket.onConnect((_) {
     print('connect');
     socket.emit('msg', 'test');
    });

    //When an event recieved from server, data is added to the stream
    socket.on('event', (data) => widget.streamSocket.addResponse);
    socket.onDisconnect((_) => print('disconnect'));

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your order placed successfully'),
      ),
      body: Container(
        // child: Text('good')
        child: StreamBuilder(
          stream: widget.streamSocket.getResponse,
          builder: (context, snapshot){
            if(snapshot.hasData){
              return Text(
                snapshot.data.toString(),
                style: TextStyle(fontSize: 20),
              );
            } else if(snapshot.hasError){
              return Text(
                "error: ${snapshot.error}",
                style: TextStyle(fontSize: 20),
              );
            } 
            return CircularProgressIndicator();
          }
        ),
      ),
    );
  }
}