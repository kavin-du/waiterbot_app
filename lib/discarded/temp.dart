import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class Temp extends StatefulWidget {
  @override
  _TempState createState() => _TempState();
}

class _TempState extends State<Temp> {
  Artboard _riveArtboard;
  RiveAnimationController _controller;
  @override
  void initState() {
    super.initState();
    rootBundle.load('animations/juice063.riv').then((data) async {
      final file = RiveFile();
      if (file.import(data)) {
        final artboard = file.mainArtboard;
        artboard.addController(_controller = SimpleAnimation('walk'));
        setState(() {
          _riveArtboard = artboard;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // pending -
    // preparing - 
    // delivering - 
    // delivered - 
    // cancelled
    return Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.greenAccent,
        body: Column(
          children: [
            // Container(
            //   clipBehavior: Clip.hardEdge,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(25),
            //     color: Colors.red,
            //   ),
            //   height: 200,
            //   width: 200,
            //   child: Rive(
            //     artboard: _riveArtboard,
            //   ),
            // ),
            // Container(
            //   // preparing
            //   height: 200,
            //   child: FlareActor(
            //     "animations/Sushi.flr",
            //     animation: "Sushi Bounce",
            //   ),
            // ),
            // Container(
            //   // delivering
            //   height: 200,
            //   child: FlareActor(
            //     "animations/Robot.flr",
            //     animation: "reposo",
            //   ),
            // ),
            // Container(
            //   // pending
            //   height: 200,
            //   child: FlareActor(
            //     "animations/Liquid_Loader.flr",
            //     animation: "Untitled",
            //   ),
            // ),
            Container(
              // done
              height: 200,
              child: FlareActor(
                "animations/success_check.flr",
                animation: "Untitled",
              ),
            ),
            Container(
              // cancelled
              height: 200,
              child: FlareActor(
                "animations/cancel_button.flr",
                animation: "Error",
              ),
            ),
            // Container(
            //   height: 200,
            //   child: FlareActor(
            //     "animations/Loading_error_and_check.flr",
            //     animation: "Loading",
            //   ),
            // )
          ],
        ));
  }
}
