import 'package:amikoj/components/chart.dart';
import 'package:amikoj/pages/round_page.dart';
import 'package:amikoj/redux/app_state.dart';
import 'package:amikoj/redux/user_reducer.dart';
import 'package:amikoj/services/realtime_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

const REDIRECT = 'REDIRECT';
const SHOW_SCORE_TABLE = 'SHOW_SCORE_TABLE';
const RESET_TIMER = 'RESET_TIMER';

void execute(dynamic command, BuildContext ctx) async {
  if (command == null) {
    return;
  }
  String cmd = command['command'];
  String value = command['value'];
  String meta = command['meta'];
  switch(cmd) {
    case REDIRECT:
      Navigator.pushNamed(ctx, value,
          arguments: meta);
      break;
    case SHOW_SCORE_TABLE:
      showScoreTable(ctx);
      break;
    case RESET_TIMER:
      getTimerController().resetTimer();
      break;
  }
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


