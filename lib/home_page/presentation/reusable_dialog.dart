import 'package:flutter/material.dart';

class ShowAlertDialog extends StatelessWidget {
  
  final String text;
  final Function function;

  const ShowAlertDialog({this.text, this.function});
  
  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      titlePadding: EdgeInsets.only(top: 15, left: 10, right: 10),
      title: Text(text),
      actions: [
        FlatButton(
            onPressed: function,
            child: Text('Yes',style: TextStyle(fontWeight: FontWeight.bold),)),
        FlatButton(
            onPressed: (){Navigator.pop(context);},
            child: Text('No', style: TextStyle(fontWeight: FontWeight.bold),)),
      ],
    );
  }
}
