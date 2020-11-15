import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Licence extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
            fontSize: 15),
        text: 'Agree to Terms & Conditions',
        recognizer: TapGestureRecognizer()
          ..onTap = () => showAlertDialog(context),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // create button
    Widget okButton = FlatButton(
      child: Text('OKAY'),
      onPressed: () {
        Navigator.of(context, rootNavigator: true)
            .pop(); // navigating to root, otherwise black screen
      },
    );

    // create alertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Terms and Conditions'),
      content: Text('this is the content of terms and conditions'),
      actions: [okButton],
    );

    // show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}
