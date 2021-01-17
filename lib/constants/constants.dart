library constants;

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';

const Color backgroundColor = Color(0xFFEEE3FA);
const TextStyle whiteText = const TextStyle(
  fontSize: 20.0,
  color: Colors.white,
  fontWeight: FontWeight.w500,
);

const TextStyle smallWhiteText = const TextStyle(
  fontSize: 13.0,
  color: Colors.white,
  fontWeight: FontWeight.w500,
);

List<dynamic> questions;

List<dynamic> getQuestions() {
  return questions;
}

void initQuestions(BuildContext context) async {
  String data = await DefaultAssetBundle.of(context).loadString("assets/data/questions.json");
  questions = json.decode(data)['questions'];
}