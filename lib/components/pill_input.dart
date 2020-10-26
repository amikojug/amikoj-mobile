import 'package:flutter/material.dart';
import 'dart:ui';

class PillInput extends StatelessWidget {
  final String labelText;
  final TextEditingController textEditingController;

  PillInput(this.labelText, this.textEditingController);

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: textEditingController,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28.0,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            floatingLabelBehavior:FloatingLabelBehavior.always,
            labelText: this.labelText,
            labelStyle: TextStyle(
              color: Colors.white,
            ),
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: EdgeInsets.all(19.0),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(36)),
              borderSide: BorderSide(width: 4,color: Colors.white),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 1,color: Colors.orange),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(40)),
              borderSide: BorderSide(width: 4,color: Colors.white),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(width: 1,)
            ),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(width: 1,color: Colors.black)
            ),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(width: 1,color: Colors.yellowAccent)
            ),
          )
      ),
    );
  }
}
