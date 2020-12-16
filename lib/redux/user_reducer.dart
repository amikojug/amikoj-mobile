import 'package:redux/redux.dart';
import 'package:amikoj/redux/user_state.dart';

final userReducer = combineReducers<UserState>([
  TypedReducer<UserState, UpdateUser>(_updateUser),
  TypedReducer<UserState, UpdateUserUid>(_updateUserUid),
  TypedReducer<UserState, UpdateUserName>(_updateUserName),
  TypedReducer<UserState, UpdateUserReadiness>(_updateUserReadiness),
  TypedReducer<UserState, ResetUser>(_resetUser),
  TypedReducer<UserState, UpdateUserSelectedAnswer>(_updateUserSelectedAnswer),
]);

UserState _updateUser(UserState state, UpdateUser action) {
  return UserState.fromJson({
    ...state.toJson(),
    "avatarUrl": action.avatarUrl,
  });
}

UserState _updateUserName(UserState state, UpdateUserName action) {
  return UserState.fromJson({
    ...state.toJson(),
    "name": action.name,
  });
}

UserState _updateUserReadiness(UserState state, UpdateUserReadiness action) {
  return UserState.fromJson({
    ...state.toJson(),
    "isReady": action.isReady,
  });
}

UserState _updateUserSelectedAnswer(UserState state, UpdateUserSelectedAnswer action) {
  return UserState.fromJson({
    ...state.toJson(),
    "selectedAnswer": action.selectedAnswer,
  });
}

UserState _updateUserUid(UserState state, UpdateUserUid action) {
  return UserState.fromJson({
    ...state.toJson(),
    "uid": action.uid,
  });
}

UserState _resetUser(UserState state, ResetUser action) {
  return UserState.initial();
}

// Actions
class UpdateUser {
  final String avatarUrl;
  UpdateUser({this.avatarUrl});
}

class UpdateUserUid {
  final String uid;
  UpdateUserUid({this.uid});
}

class UpdateUserName {
  final String name;
  UpdateUserName({this.name});
}

class UpdateUserReadiness {
  final bool isReady;
  UpdateUserReadiness({this.isReady});
}

class UpdateUserSelectedAnswer {
  final String selectedAnswer;
  UpdateUserSelectedAnswer({this.selectedAnswer});
}

class ResetUser {
  ResetUser();
}