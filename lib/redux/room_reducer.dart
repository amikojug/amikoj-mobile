import 'package:amikoj/redux/room_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';

final roomReducer = combineReducers<RoomState>([
  TypedReducer<RoomState, UpdateRoom>(_updateRoom),
  TypedReducer<RoomState, ResetRoom>(_resetRoom)
]);

RoomState _updateRoom(RoomState state, UpdateRoom action) {
  return new RoomState(players: action.players);
}

RoomState _resetRoom(RoomState state, ResetRoom action) {
  return RoomState.initial();
}
 // Actions

class UpdateRoom {
  final List<String> players;
  UpdateRoom({ this.players });
}

class ResetRoom {
  ResetRoom();
}