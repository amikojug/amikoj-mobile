import 'package:amikoj/components/chart.dart';
import 'package:amikoj/models/user_module.dart';
import 'package:amikoj/redux/app_state.dart';
import 'package:amikoj/redux/user_reducer.dart';
import 'package:amikoj/services/realtime_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:synchronized/synchronized.dart';

const REDIRECT = 'REDIRECT';
const SHOW_SCORE_TABLE = 'SHOW_SCORE_TABLE';

var lock = new Lock();

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
      _showScoreTable(ctx);
      break;
  }
}

Future<void> _showScoreTable(BuildContext ctx) async {
  return showDialog<void>(
    context: ctx,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('AlertDialog Title'),
        content: HorizontalBarChart.withSampleData(),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}



