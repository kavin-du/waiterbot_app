import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class Temp extends StatefulWidget {
  @override
  _TempState createState() => _TempState();
}

class _TempState extends State<Temp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Container(
              height: 250,
              child: FlareActor(
                "animations/success_check.flr",
                // snapToEnd: true,
                animation: "Untitled",
              ),
            ),
            Container(
              height: 250,
              child: FlareActor(
                "animations/Loading_error_and_check.flr",
                animation: "Loading"
              )
            )
          ],
        ));
  }
}
