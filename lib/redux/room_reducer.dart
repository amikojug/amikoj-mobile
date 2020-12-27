import 'package:amikoj/models/user_module.dart';
import 'package:amikoj/redux/room_state.dart';
import 'package:redux/redux.dart';

final roomReducer = combineReducers<RoomState>([
  TypedReducer<RoomState, UpdateRoom>(_updateRoom),
  TypedReducer<RoomState, ResetRoom>(_resetRoom)
]);

RoomState _updateRoom(RoomState state, UpdateRoom action) {
  return RoomState.fromJson({
    ...state.toJson(),
    'players': action.players,
    'roomName': action.roomName,
    'hostId': action.hostId,
    'currentQuestionId': action.currentQuestionId,
    'askedPlayer': action.askedPlayer
  });
}

RoomState _resetRoom(RoomState state, ResetRoom action) {
  return RoomState.initial();
}
// Actions

class UpdateRoom {
  final List<UserModule> players;
  final String roomName;
  final String hostId;
  final String currentQuestionId;
  final String askedPlayer;
  UpdateRoom({ this.players, this.roomName, this.hostId, this.currentQuestionId, this.askedPlayer });
}

class ResetRoom {
  ResetRoom();
}