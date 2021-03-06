import 'package:amikoj/redux/app_state.dart';
import 'package:amikoj/redux/room_reducer.dart';
import 'package:amikoj/redux/user_reducer.dart';

AppState appReducer(AppState currentState, action) {
  return new AppState(
      userState: userReducer(currentState.userState, action),
      roomState: roomReducer(currentState.roomState, action)
  );
}