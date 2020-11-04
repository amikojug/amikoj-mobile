import 'dart:async';
import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

DatabaseReference _roomRef = FirebaseDatabase.instance.reference().child('rooms');
StreamSubscription<Event> _roomSubscription;


void createRoomSubscription(String roomName) {
  createSubscription(
    refPath: roomName,
    ref: _roomRef,
    subscription: _roomSubscription,
    onUpdate: (value) {
      print('KKKKKK $value');
    }
  );
}


Future updateRoom(String roomName) async {
  await updateDatabaseState(
    ref: _roomRef,
    childPath: roomName,
    callback: (e) {
      print('Callllllllllllll $e');
    },
    mutate: (val) {
      return  val == null ? "asdas" : val + "ww222";
    }
  );
}

void createSubscription({ DatabaseReference ref, StreamSubscription<Event> subscription,
  String refPath, Function(dynamic) onUpdate }) {
  final DatabaseReference targetRef = refPath.isNotEmpty ? ref.child(refPath) : ref;
  targetRef.keepSynced(true);
  subscription = targetRef.onValue.listen((Event event) {
    onUpdate(event.snapshot.value);
    print(event.snapshot.value);
  }, onError: (Object o) {
    final DatabaseError error = o;
    print('error $error');
  });
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
