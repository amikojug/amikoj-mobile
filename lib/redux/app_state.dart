import 'package:amikoj/redux/room_state.dart';
import 'package:meta/meta.dart';
import 'package:amikoj/redux/user_state.dart';

@immutable
class AppState {
  final UserState userState;
  final RoomState roomState;

  AppState({@required this.userState, @required this.roomState});

  @override
  String toString() {
    return 'AppState: {$userState}';
  }

  @override
  bool operator ==(Object other) =>
      false;

  @override
  int get hashCode => userState.hashCode;

  factory AppState.initialState() => AppState(
      userState: UserState.initial(),
      roomState: RoomState.initial()
  );
}