import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:amikoj/app.dart';
import 'package:amikoj/constants/constants.dart';
import 'package:amikoj/models/user_module.dart';
import 'package:amikoj/redux/app_state.dart';
import 'package:amikoj/redux/room_reducer.dart';
import 'package:amikoj/redux/room_state.dart';
import 'package:amikoj/redux/user_reducer.dart';
import 'package:amikoj/services/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

import 'commandExecutor.dart';

DatabaseReference _roomRef =
    FirebaseDatabase.instance.reference().child('rooms');
StreamSubscription<Event> _roomSubscription;
final AuthService _auth = AuthService();
final uuid = Uuid();

Future sendRedirectToRoundPage(BuildContext ctx) async {
  dynamic cmd = {
    'command': REDIRECT,
    'value': '/round',
    'meta': null,
  };
  await sendCommand(cmd, ctx);
}

Future sendShowScoreTable(BuildContext ctx) async {
  dynamic cmd = {
    'command': SHOW_SCORE_TABLE,
    'value': null,
    'meta': null,
  };
  await sendCommand(cmd, ctx);
}

Future sendResetTimer(BuildContext ctx) async {
  dynamic cmd = {
    'command': RESET_TIMER,
    'value': null,
    'meta': null,
  };
  await sendCommand(cmd, ctx);
}

bool isRoomRefNull() {
  return _roomSubscription == null;
}

Future increaseScore(List<UserModule> players, BuildContext ctx) async {
  Store<AppState> s = getStore();
  String roomId = s.state.roomState.roomName;
  List<String> uids = List<String>.from(players.map((e) => e.uid));
  if (roomId == null) {
    return;
  }
  updateRoom(roomId, (val) {
    List<dynamic> players = List<dynamic>.of(val['players']);
    players.forEach((player) {
      if (uids.contains(player['uid'])) {
        player['score'] = player['score'] + 1;
      }
    });
    Map<String, dynamic> data = {
      ...val,
      "players": players,
    };
    return data;
  });
}

Future sendIncrease(List<UserModule> players, BuildContext ctx) async {
  String hostId = StoreProvider.of<AppState>(ctx).state.roomState.hostId;
  String userId = _auth.getCurrentUser().uid;
  if (hostId == userId) {
    await increaseScore(players, ctx);
    await sendShowScoreTable(ctx);
    await changeQuestion(ctx);
  }
}

Future sendCommand(dynamic command, BuildContext ctx) async {
  Store<AppState> s = getStore();
  String roomId = s.state.roomState.roomName;
  if (roomId == null) {
    return;
  }
  var commandHash = uuid.v4();
  updateRoom(roomId, (val) {
    List<dynamic> players = List<dynamic>.of(val['players']);
    players.forEach((player) {
      player['command'] = command;
      player['commandHash'] = commandHash;
    });
    Map<String, dynamic> data = {
      ...val,
      "players": players,
    };
    return data;
  });
}

Future changeQuestion(BuildContext ctx) async {
  print('changeQuestion1');
  Store<AppState> s = getStore();
  String roomId = s.state.roomState.roomName;
  if (roomId == null) {
    return;
  }
  print('changeQuestion2');
  updateRoom(roomId, (val) {
    List<dynamic> players = List<dynamic>.of(val['players']);
    var player = getNextPlayer();
    var question = getNextQuestion();
    players.forEach((player) {
      player['selectedAnswer'] = null;
    });
    Map<String, dynamic> data = {
      ...val,
      "players": players,
      "currentQuestionId": question,
      "askedPlayer": players[player]['uid'],
      "totalQuestions": val['totalQuestions'] + 1
    };
    return data;
  });
  StoreProvider.of<AppState>(ctx)
      .dispatch(UpdateUserSelectedAnswer(selectedAnswer: null));
}

int getNextPlayer() {
  Store<AppState> s = getStore();
  RoomState roomState = s.state.roomState;
  List players = roomState.players;
  int index =
      players.indexWhere((element) => element.uid == roomState.askedPlayer);
  if (index == players.length - 1 || index == -1) {
    return 0;
  } else {
    return index + 1;
  }
}

int getNextQuestion() {
  Store<AppState> s = getStore();
  RoomState roomState = s.state.roomState;
  List players = roomState.players;
  var rng = new Random();
  var numberOfQuestions = getQuestions().length;
  int index =
      players.indexWhere((element) => element.uid == roomState.askedPlayer);
  if (index == -1) {
    return rng.nextInt(numberOfQuestions);
  } else if (int.parse(roomState.currentQuestionId) == numberOfQuestions - 1) {
    return 0;
  } else {
    return int.parse(roomState.currentQuestionId) + 1;
  }
}

Future removeYourselfFromRoom() async {
  UserModule currentUser = _auth.getCurrentUser();
  Store<AppState> s = getStore();
  String roomId = s.state.roomState.roomName;
  if (roomId == null) {
    return;
  }
  await updateRoom(roomId, (val) {
    if (val != null) {
      bool playersAlreadyExistInRoom = [...val["players"]]
          .any((element) => element["uid"] == currentUser.uid);
      dynamic playersWithoutCurrentPlayer = [...val["players"]]
          .where((element) => element["uid"] != currentUser.uid);
      if (playersAlreadyExistInRoom) {
        Map<String, dynamic> data = {
          ...val,
          "players": [...playersWithoutCurrentPlayer],
        };
        return data;
      }
    }
    return val;
  });
}

Future addYourselfToTheRoom(String roomId) async {
  UserModule currentUser = _auth.getCurrentUser();
  Store<AppState> s = getStore();
  var state = {...s.state.userState.toJson()};
  state["isReady"] = false;
  await updateRoom(roomId, (val) {
    if (val != null) {
      dynamic players = val["players"] == null ? [] : val["players"];
      bool playersAlreadyExistInRoom =
          players.any((element) => element["uid"] == currentUser.uid);
      if (!playersAlreadyExistInRoom) {
        Map<String, dynamic> data = {
          ...val,
          "players": [
            ...players,
            state,
          ]
        };
        return data;
      }
    }
    return val;
  });
}

Future removePlayerFromRoom(String uid) async {
  Store<AppState> s = getStore();
  String roomId = s.state.roomState.roomName;
  if (roomId == null) {
    return;
  }
  var commandHash = uuid.v4();
  dynamic cmd = {
    'command': REDIRECT,
    'value': '/home',
    'meta': null,
  };
  await updateRoom(roomId, (val) {
    List<dynamic> players = List<dynamic>.of(val['players']);
    players.forEach((player) {
      if (uid == player['uid']) {
        player['command'] = cmd;
        player['commandHash'] = commandHash;
      }
    });
    Map<String, dynamic> data = {
      ...val,
      "players": players,
    };
    return data;
  });

  await updateRoom(roomId, (val) {
    print(s.state.userState.toJson());
    if (val != null) {
      bool playersAlreadyExistInRoom =
          [...val["players"]].any((element) => element["uid"] == uid);
      dynamic playersWithoutCurrentPlayer =
          [...val["players"]].where((element) => element["uid"] != uid);
      if (playersAlreadyExistInRoom) {
        Map<String, dynamic> data = {
          ...val,
          "players": [...playersWithoutCurrentPlayer]
        };
        return data;
      }
    }
    return val;
  });
}

Future updateYourselfInTheRoom() async {
  UserModule currentUser = _auth.getCurrentUser();
  Store<AppState> s = getStore();
  String roomId = s.state.roomState.roomName;
  if (roomId == null) {
    return;
  }
  await updateRoom(roomId, (val) {
    print(s.state.userState.toJson());
    if (val != null) {
      bool playersAlreadyExistInRoom = [...val["players"]]
          .any((element) => element["uid"] == currentUser.uid);
      dynamic playersWithoutCurrentPlayer = [...val["players"]]
          .where((element) => element["uid"] != currentUser.uid);
      if (playersAlreadyExistInRoom) {
        Map<String, dynamic> data = {
          ...val,
          "players": [
            ...playersWithoutCurrentPlayer,
            {
              ...s.state.userState.toJson(),
            }
          ]
        };
        return data;
      }
    }
    return val;
  });
}

Future initRoom(String roomId) async {
  UserModule currentUser = _auth.getCurrentUser();
  Store<AppState> store = getStore();
  await updateRoom(roomId, (val) {
    return {
      "hostId": currentUser.uid,
      "players": [
        {
          ...store.state.userState.toJson(),
        }
      ],
      "totalQuestions": 0
    };
  });
}

void createRoomSubscription(String roomName, BuildContext context) {
  createSubscription(
      refPath: roomName,
      ref: _roomRef,
      subscription: _roomSubscription,
      onUpdate: (value) {
        if (value != null) {
          Map<String, dynamic> room = Map<String, dynamic>.from(value);
          StoreProvider.of<AppState>(context).dispatch(UpdateRoom(
              players: usersFromJson(room, context),
              roomName: roomName,
              hostId: room['hostId'],
              currentQuestionId: room['currentQuestionId'].toString(),
              askedPlayer: room['askedPlayer']));
        }
        print('KKKKKK $value');
      });
}

Future updateRoom(String roomName, Function(dynamic) mutate) async {
  await updateDatabaseState(
    ref: _roomRef,
    childPath: roomName,
    callback: (e) {
      print('updateRoom.callback: $e');
    },
    mutate: mutate,
  );
}

void createSubscription(
    {DatabaseReference ref,
    StreamSubscription<Event> subscription,
    String refPath,
    Function(dynamic) onUpdate}) {
  if (subscription == null) {
    final DatabaseReference targetRef =
        refPath.isNotEmpty ? ref.child(refPath) : ref;
    targetRef.keepSynced(true);
    subscription = targetRef.onValue.listen((Event event) {
      print("subscription: ${event.snapshot.value}");
      onUpdate(event.snapshot.value);
    }, onError: (Object o) {
      final DatabaseError error = o;
      print('error $error');
    });
  }
}

void cancelSubscription(StreamSubscription<Event> subscription) {
  subscription.cancel();
}

Future<void> updateDatabaseState(
    {DatabaseReference ref,
    String childPath,
    Function(dynamic) mutate,
    Function(dynamic) callback}) async {
  final DatabaseReference targetRef =
      childPath.isNotEmpty ? ref.child(childPath) : ref;
  final TransactionResult transactionResult =
      await targetRef.runTransaction((MutableData mutableData) async {
    mutableData.value = mutate(mutableData.value);
    return mutableData;
  });

  if (transactionResult.committed) {
    if (callback != null) {
      callback(transactionResult.dataSnapshot.value);
    }
    print(transactionResult.dataSnapshot.value);
  } else {
    print('Transaction not committed.');
    if (transactionResult.error != null) {
      print(transactionResult.error.message);
    }
  }
}
