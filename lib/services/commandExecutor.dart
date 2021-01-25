import 'package:amikoj/components/chart.dart';
import 'package:amikoj/constants/constants.dart';
import 'package:amikoj/constants/room_action_type.dart';
import 'package:amikoj/pages/round_page.dart';
import 'package:amikoj/redux/app_state.dart';
import 'package:amikoj/redux/user_reducer.dart';
import 'package:amikoj/services/realtime_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'auth.dart';

const REDIRECT = 'REDIRECT';
const SHOW_SCORE_TABLE = 'SHOW_SCORE_TABLE';
const SHOW_CORRECT_DIALOG = 'SHOW_CORRECT_DIALOG';
const RESET_TIMER = 'RESET_TIMER';

final AuthService _auth = AuthService();

void execute(dynamic command, BuildContext ctx) async {
  if (command == null) {
    return;
  }
  String cmd = command['command'];
  String value = command['value'];
  dynamic meta = command['meta'];
  switch(cmd) {
    case REDIRECT:
      print("JJJJJJJJJ");
      dynamic args;
      RoomAction action;
      if (meta != null) {
        RoomAction action = RoomAction.values.firstWhere((e) => e.toString() == meta['type']);
        args = { 'type': action, 'roomName': meta['roomName'] };
      }
      print("JJJJJJJJJ1");
      await Navigator.pushNamed(ctx, value,
          arguments: args);
      break;
    case SHOW_SCORE_TABLE:
      showScoreTable(ctx);
      break;
    case RESET_TIMER:
      getTimerController().resetTimer();
      break;
    case SHOW_CORRECT_DIALOG:
      showCorrectDialog(ctx, value);
      break;
  }
}

Future<void> showCorrectDialog(BuildContext ctx, String value) async {
  String playerId = _auth.getCurrentUser().uid;
  bool rightAnswer = value.contains(playerId);
  String contentText = rightAnswer ? "Right Answer" : "Wrong Answer";
  TextStyle contentStyle = rightAnswer ? greenText : redText;
  bool amIAsked = value.contains("[$playerId]");
  contentText = amIAsked ? "Nice Answer" : contentText;
  contentStyle = amIAsked ? greenText : contentStyle;
  return showDialog<void>(
    context: ctx,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Result', style: TextStyle(
            color: Colors.white
        ),),
        content: Container(
          child: Text(contentText, style: contentStyle,),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(36.0),
          side: BorderSide(width: 2.0, color: Colors.lightBlue.shade50),),
        backgroundColor: Color(0xAA000000),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              getTimerController().resetTimer();
            },
          ),
        ],
      );
    },
  );
}

Future<void> showScoreTable(BuildContext ctx) async {
  return showDialog<void>(
    context: ctx,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Score', style: TextStyle(
          color: Colors.white
        ),),
        content: HorizontalBarChart.withSampleData(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(36.0),
          side: BorderSide(width: 2.0, color: Colors.lightBlue.shade50),),
        backgroundColor: Color(0x77000000),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              getTimerController().resetTimer();
            },
          ),
        ],
      );
    },
  );
}



