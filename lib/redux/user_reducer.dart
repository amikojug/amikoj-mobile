import 'package:redux/redux.dart';
import 'package:amikoj/redux/user_state.dart';

final userReducer = combineReducers<UserState>([
  TypedReducer<UserState, UpdateUser>(_updateUser),
  TypedReducer<UserState, ResetUser>(_resetUser),
]);

UserState _updateUser(UserState state, UpdateUser action) {
  return new UserState(avatarUrl: action.avatarUrl);
}

UserState _resetUser(UserState state, ResetUser action) {
  return UserState.initial();
}

// Actions
class UpdateUser {
  final String avatarUrl;
  UpdateUser({this.avatarUrl});
}

class ResetUser {
  ResetUser();
}