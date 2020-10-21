import 'package:flutter/material.dart';
import 'dart:ui';

class PillButton extends StatelessWidget {
  final String text;

  PillButton(this.text);

  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(36.0),
          side: BorderSide(color: Colors.white, width: 4)
      ),
      color: Colors.transparent,
      textColor: Colors.white,
      padding: EdgeInsets.all(19.0),
      minWidth: double.infinity,
      onPressed: () {
        Navigator.pushNamed(context, '/login');
      },
      child: Text(
        this.text,
        style: TextStyle(
          fontSize: 28.0,
        ),
      ),
    );
  }
}
