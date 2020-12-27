import 'package:amikoj/redux/app_state.dart';
import 'package:amikoj/redux/user_reducer.dart';
import 'package:amikoj/services/auth.dart';
import 'package:amikoj/services/commandExecutor.dart';
import 'package:amikoj/services/realtime_database.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

final AuthService _auth = AuthService();

class UserModule {
  final String uid;
  String avatarUrl;
  String name = "Best Name";
  bool isReady = false;
  dynamic command;

  UserModule({this.uid, this.avatarUrl, this.name, this.isReady, this.command});

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'uid': uid,
        'avatarUrl': avatarUrl,
        'isReady': isReady,
        'command': command,
      };
}

UserModule fromJson(Map<String, dynamic> json) {
  return new UserModule(
      uid: json["uid"],
      avatarUrl: json["avatarUrl"],
      name: json["name"],
      isReady: json["isReady"],
      command: json["command"],
  );
}

List<UserModule> usersFromJson(Map<String, dynamic> json, BuildContext context) {
  List<UserModule> results = new List();
  List<dynamic> players = json["players"] == null ? [] : json["players"];
  players.forEach((element) {
    results.add(fromJson(Map<String, dynamic>.from(element)));
  });
  executeCommandOnCurrentUser(context, players);
  return results;
}

void executeCommandOnCurrentUser(BuildContext context, List<dynamic> players) async {
  var userId = _auth.getCurrentUser().uid;
  dynamic command = players.where((element) => element['uid'] == userId).first['command'];
  String commandHash = players.where((element) => element['uid'] == userId).first['commandHash'];
  if (StoreProvider.of<AppState>(context).state.userState.commandHash != commandHash) {
    await StoreProvider.of<AppState>(context)
        .dispatch(UpdateUserCommandHash(
        commandHash: commandHash,
        ctx: context
    ));
    execute(command, context);
  }
}

class UserData {
  final String uid;
  final String name;
  final String sugars;
  final int strength;

  UserData({this.uid, this.name, this.sugars, this.strength});
}
