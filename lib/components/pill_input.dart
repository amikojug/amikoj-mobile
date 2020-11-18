import 'package:flutter/material.dart';
import 'dart:ui';

class PillInput extends StatelessWidget {
  final String labelText;
  final TextEditingController textEditingController;
  final bool obscureText;
  final Function validator;

  PillInput(
    this.labelText,
    this.textEditingController, {
    Key key,
    this.obscureText = false,
    this.validator,
  }) : super(key: key);

  Widget build(BuildContext context) {
    print(validator);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
          validator: this.validator,
          obscureText: this.obscureText,
          controller: textEditingController,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28.0,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            errorStyle: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: this.labelText,
            labelStyle: TextStyle(
              color: Colors.white,
            ),
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: EdgeInsets.all(19.0),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(36)),
              borderSide: BorderSide(width: 4, color: Colors.white),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 1, color: Colors.orange),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(40)),
              borderSide: BorderSide(width: 4, color: Colors.white),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(
                  width: 1,
                )),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(width: 1, color: Colors.black)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(width: 1, color: Colors.yellowAccent)),
          )),
    );
  }
}
