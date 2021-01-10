import 'package:amikoj/services/commandExecutor.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import 'package:amikoj/redux/user_state.dart';

final userReducer = combineReducers<UserState>([
  TypedReducer<UserState, UpdateUser>(_updateUser),
  TypedReducer<UserState, UpdateUserUid>(_updateUserUid),
  TypedReducer<UserState, UpdateUserName>(_updateUserName),
  TypedReducer<UserState, UpdateUserReadiness>(_updateUserReadiness),
  TypedReducer<UserState, ResetUser>(_resetUser),
  TypedReducer<UserState, UpdateUserSelectedAnswer>(_updateUserSelectedAnswer),
  TypedReducer<UserState, UpdateUserCommand>(_updateUserCommand),
  TypedReducer<UserState, UpdateUserCommandHash>(_updateUserCommandHash),
  TypedReducer<UserState, UpdateUserScore>(_updateUserScore),
  TypedReducer<UserState, UpdateWholeUser>(_updateWholeUser),

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

UserState _updateUserCommand(UserState state, UpdateUserCommand action) {
  return UserState.fromJson({
    ...state.toJson(),
    "command": action.command,
  });
}

UserState _updateUserCommandHash(UserState state, UpdateUserCommandHash action) {
  return UserState.fromJson({
    ...state.toJson(),
    "commandHash": action.commandHash,
  });
}

UserState _updateUserScore(UserState state, UpdateUserScore action) {
  return UserState.fromJson({
    ...state.toJson(),
    'score': state.score + 1
  });
}

UserState _updateWholeUser(UserState state, UpdateWholeUser action) {
  return UserState.fromJson(action.user);
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

class UpdateUserCommand {
  final dynamic command;
  final BuildContext ctx;
  UpdateUserCommand({this.command, this.ctx});
}

class UpdateUserCommandHash {
  final String commandHash;
  final BuildContext ctx;
  UpdateUserCommandHash({this.commandHash, this.ctx});
}

class UpdateUserScore {
  UpdateUserScore();
}

class UpdateWholeUser {
  final Map<String, dynamic> user;
  UpdateWholeUser({this.user});
}

class ResetUser {
  ResetUser();
}