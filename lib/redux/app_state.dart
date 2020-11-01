import 'package:meta/meta.dart';
import 'package:amikoj/redux/user_state.dart';

@immutable
class AppState {
  final UserState userState;

  AppState({@required this.userState});

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
      userState: UserState.initial()
  );
}