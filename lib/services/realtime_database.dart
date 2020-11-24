import 'dart:async';
import 'dart:io' show Platform;
import 'package:amikoj/app.dart';
import 'package:amikoj/models/user_module.dart';
import 'package:amikoj/redux/app_state.dart';
import 'package:amikoj/redux/room_reducer.dart';
import 'package:amikoj/services/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

DatabaseReference _roomRef = FirebaseDatabase.instance.reference().child('rooms');
StreamSubscription<Event> _roomSubscription;
final AuthService _auth = AuthService();

Future removeYourselfFromRoom() async {
  UserModule currentUser = _auth.getCurrentUser();
  Store<AppState> s = getStore();
  String roomId = s.state.roomState.roomName;
  if (roomId == null) {
    return;
  }
  await updateRoom(roomId, (val) {
    if (val != null) {
      bool playersAlreadyExistInRoom = [...val["players"]].any((element) => element["uid"] == currentUser.uid);
      dynamic playersWithoutCurrentPlayer = [...val["players"]].where((element) => element["uid"] != currentUser.uid);
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
  await updateRoom(roomId, (val) {
    if (val != null) {
      dynamic players = val["players"] == null ? [] : val["players"];
      bool playersAlreadyExistInRoom = players.any((element) => element["uid"] == currentUser.uid);
      if (!playersAlreadyExistInRoom) {
        Map<String, dynamic> data = {
          ...val,
          "players": [...players, {
            ...s.state.userState.toJson()
          }]
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
  String avatarUrl = s.state.userState.avatarUrl;
  await updateRoom(roomId, (val) {
    print("Asasasaw");
    print({
      ...s.state.userState.toJson()
    });
    print(s.state.userState.toJson());
    if (val != null) {
      bool playersAlreadyExistInRoom = [...val["players"]].any((element) => element["uid"] == currentUser.uid);
      dynamic playersWithoutCurrentPlayer = [...val["players"]].where((element) => element["uid"] != currentUser.uid);
      dynamic currentPlayer = [...val["players"]].where((element) => element["uid"] == currentUser.uid).first;
      if (playersAlreadyExistInRoom) {
        Map<String, dynamic> data = {
          ...val,
          "players": [...playersWithoutCurrentPlayer, {
            ...s.state.userState.toJson(),
          }]
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
  String avatarUrl = store.state.userState.avatarUrl;
  await updateRoom(roomId, (val) {
    return {
      "hostId": currentUser.uid,
      "players": [{
        ...store.state.userState.toJson(),
      }]
    };
  });
}

void createRoomSubscription(String roomName, BuildContext context) {
  createSubscription(
    refPath: roomName,
    ref: _roomRef,
    subscription: _roomSubscription,
    onUpdate: (value) {
      print("qqqqqqqqqq1");
      print(Map<String, dynamic>.from(value)['hostId']);
      StoreProvider.of<AppState>(context)
          .dispatch(UpdateRoom(
          players: usersFromJson(Map<String, dynamic>.from(value)),
          roomName: roomName,
          hostId: Map<String, dynamic>.from(value)['hostId'],
      ));
      print('KKKKKK $value');
    }
  );
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

void createSubscription({ DatabaseReference ref, StreamSubscription<Event> subscription,
  String refPath, Function(dynamic) onUpdate }) {
  if (subscription == null) {
    final DatabaseReference targetRef = refPath.isNotEmpty ? ref.child(refPath) : ref;
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

Future<void> updateDatabaseState({ DatabaseReference ref, String childPath,
    Function(dynamic) mutate, Function(dynamic) callback }) async {
  final DatabaseReference targetRef = childPath.isNotEmpty ? ref.child(childPath) : ref;
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
