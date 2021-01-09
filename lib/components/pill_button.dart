import 'package:flutter/material.dart';
import 'dart:ui';

class PillButton extends StatelessWidget {
  final String text;
  final String redirect;
  final Function action;
  final dynamic redirectArgument;
  final bool valid;

  PillButton(this.text,
      {this.redirect, this.action, this.redirectArgument, this.valid});

  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    // double _height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _width * 0.05),
      child: Container(
        decoration: BoxDecoration(color: Colors.transparent, boxShadow: []),
        child: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(36.0),
              side: BorderSide(color: Colors.white, width: 4)),
          color: Colors.transparent,
          textColor: Colors.white,
          padding: EdgeInsets.all(_width * 0.1 / 2.5),
          minWidth: double.infinity,
          onPressed: () async {
            if (this.action != null) action();
            if (this.valid != null && this.valid) {
              if (this.redirect != null)
                Navigator.pushNamed(context, this.redirect,
                    arguments: this.redirectArgument);
            }
          },
          child: Text(
            this.text,
            style: TextStyle(
              fontSize: _width * 0.07,
            ),
          ),
        ),
      ),
    );
  }
}
