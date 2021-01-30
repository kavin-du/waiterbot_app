
import 'package:flutter/material.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:waiterbot_app/services/app_urls.dart';




class Socket2 extends StatefulWidget {
  @override
  _Socket2State createState() => _Socket2State();
}
enum ConnectionStatus{
  connected,
  disconnected
}
class _Socket2State extends State<Socket2> {
  SocketIOManager manager = SocketIOManager();
  SocketIO socket;
  var status = ConnectionStatus.disconnected;

  static_socketStatus(dynamic data) { 
	  print("Socket status: " + data); 
  } 

  _newsEventHandler(dynamic message){
    print("news received");
    setState(() {
      messages.add(message.toString());
    });
  }
  @override
  void initState() { 
    super.initState();
    setupSocketConnections();
  }
    void disconnectSocketConnections() async{ 
      await manager.clearInstance(socket);
      status = ConnectionStatus.disconnected;
      print("disconnected");
    }

    void sendMessage(){ 
      if(status == ConnectionStatus.connected){
        socket.emit("news", [asd.text]);
      setState(() {
      messages.add(asd.text.toString());
      });
      asd.text = "";
      }
     

    }
    void setupSocketConnections() async {
      socket = await manager.createInstance(SocketOptions(AppUrls.websocketUrl));
      socket.onConnect((data){
        status = ConnectionStatus.connected;
        print("connected...");
      });
      socket.onConnectError((data){
        print("Connection Error");
      });
      socket.onConnectTimeout((data){
        print("Connection Timed Out");
      });
      socket.on("news", (data){   //sample event
       _newsEventHandler(data);
      });
      socket.connect();
    }

  List<String> messages = new List<String>();
  @override
    void dispose() {
      super.dispose();
    }
TextEditingController asd = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
             body: SingleChildScrollView(
                child: Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                        children: <Widget>[
                          new Container(
                            height: MediaQuery.of(context).padding.top
                          ),
                          RaisedButton(
                            child: new Text("Disconnect"),
                            onPressed: disconnectSocketConnections,
                          ),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 35,
                                width: 200,
                                child: new TextField(
                                  controller: asd,
                                ),
                              ),
                              new Container(width: 10,)
                              ,
                              new RaisedButton(
                                onPressed: sendMessage,
                                child: new Text("send"),
                              )
                            ],
                          ),
                          Container(height: 20,),


                          new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[new Column(children: messages?.map((f) => new Column( children : <Widget>[ new Text(f,style: TextStyle(fontSize: 20)),new Container(height: 5,)]))?.toList()?? [])])
                          

                        ],
                      ),
                ),
      ),
             ),

    );
  }
}
