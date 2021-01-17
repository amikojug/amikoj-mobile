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
  int score;
  String selectedAnswer;

  UserModule({this.uid, this.avatarUrl, this.name, this.isReady, this.command, this.score, this.selectedAnswer});

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'uid': uid,
        'avatarUrl': avatarUrl,
        'isReady': isReady,
        'command': command,
        'score': score,
        'selectedAnswer': selectedAnswer,
      };
}

UserModule fromJson(Map<String, dynamic> json) {
  return new UserModule(
      uid: json["uid"],
      avatarUrl: json["avatarUrl"],
      name: json["name"],
      isReady: json["isReady"],
      command: json["command"],
      score: json["score"],
      selectedAnswer: json["selectedAnswer"],
  );
}

List<UserModule> usersFromJson(Map<String, dynamic> json, BuildContext context) {
  List<UserModule> results = new List();
  List<dynamic> players = json["players"] == null ? [] : json["players"];
  players.forEach((element) {
    results.add(fromJson(Map<String, dynamic>.from(element)));
  });
  dynamic player = players
      .where((element) => element['uid'] == _auth.getCurrentUser().uid).first;
  executeCommandOnCurrentUser(context, players);
  updateCurrentUserOnRoomChange(player, context);
  watchOnEndOfRound(context, players);
  return results;
}

void updateCurrentUserOnRoomChange(dynamic player, BuildContext context) {
  StoreProvider.of<AppState>(context)
      .dispatch(UpdateWholeUser(user: Map<String, dynamic>.from(player)));
}

void watchOnEndOfRound(BuildContext context, List<dynamic> players) {
  bool everyoneAnswered = isEveryoneAnswered(context, players);
  print(isEveryoneAnswered(context, players));
  bool result = true;
  StoreProvider.of<AppState>(context).state.roomState.players.forEach((element) {
    if (element.selectedAnswer == null) {
      result = false;
    }
  });
  print(result);
  if (!result && everyoneAnswered) {
    List<UserModule> playersWhoAnsweredCorrectly = getPlayersWhoAnsweredCorrectly(context, players);
    sendIncrease(playersWhoAnsweredCorrectly, context);
    playersWhoAnsweredCorrectly.forEach((element) {
      print(element.name);
    });
  }
}

List<UserModule> getPlayersWhoAnsweredCorrectly(BuildContext context, List<dynamic> players) {
  List<UserModule> result = new List();
  String askedPlayerId = StoreProvider.of<AppState>(context).state.roomState.askedPlayer;
  dynamic askedPlayer = players
      .where((player) => player['uid'] == askedPlayerId).first;
  String askedPlayerAnswer = askedPlayer['selectedAnswer'];
  print('BBBBBBBBBBBSSS123');
  print(askedPlayerAnswer);
  if (askedPlayerAnswer != 'NONE') {
    List<dynamic> playersWithoutAskedPlayer = List.from(players.where((p) => p['uid'] != askedPlayerId));
    playersWithoutAskedPlayer.forEach((player) {
      if (player['selectedAnswer'] == askedPlayerAnswer) {
        result.add(fromJson(Map<String, dynamic>.from(player)));
      }
    });
  }
  return result;
}

bool isEveryoneAnswered(BuildContext context, List<dynamic> players) {
  bool result = true;
  players.forEach((player) {
    if (player['selectedAnswer'] == null) {
      result = false;
    }
  });
  return result;
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
