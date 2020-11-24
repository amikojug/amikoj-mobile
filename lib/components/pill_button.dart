import 'package:flutter/material.dart';
import 'dart:ui';

class PillButton extends StatelessWidget {
  final String text;
  final String redirect;
  final Function action;
  final dynamic redirectArgument;

  PillButton(this.text, {this.redirect, this.action, this.redirectArgument});

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(color: Colors.transparent, boxShadow: []),
        child: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(36.0),
              side: BorderSide(color: Colors.white, width: 4)),
          color: Colors.transparent,
          textColor: Colors.white,
          padding: EdgeInsets.all(19.0),
          minWidth: double.infinity,
          onPressed: () async {
            if (this.redirect != null)
              Navigator.pushNamed(context, this.redirect, arguments: this.redirectArgument);
            if (this.action != null) action();
          },
          child: Text(
            this.text,
            style: TextStyle(
              fontSize: 28.0,
            ),
          ),
        ),
      ),
    );
  }
}
