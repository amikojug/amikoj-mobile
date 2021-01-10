import 'package:meta/meta.dart';

@immutable
class UserState {
  final String uid;
  final String avatarUrl;
  final String name;
  final bool isReady;
  final String selectedAnswer;
  final dynamic command;
  final String commandHash;
  final int score;

  UserState({
    @required this.uid,
    @required this.avatarUrl,
    @required this.name,
    @required this.isReady,
    @required this.selectedAnswer,
    @required this.command,
    @required this.commandHash,
    @required this.score
  });

  UserState.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        avatarUrl = json['avatarUrl'],
        isReady = json['isReady'],
        uid = json['uid'],
        selectedAnswer = json['selectedAnswer'],
        command = json['command'],
        commandHash = json['commandHash'],
        score = json['score'];

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'avatarUrl': avatarUrl,
        'isReady': isReady,
        'uid': uid,
        'selectedAnswer': selectedAnswer,
        'command': command,
        'commandHash': commandHash,
        'score': score,
      };

  static UserState initial() {
    return new UserState(
        avatarUrl: "https://images.pexels.com/photos/1252869/pexels-photo-1252869.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
        name: "Best name",
        isReady: false,
        uid: "",
        selectedAnswer: null,
        command: null,
        commandHash: "",
        score: 0
    );
  }

  @override
  String toString() {
    return 'UserState: {avatarUrl: $avatarUrl} {name: $name} {isReady: $isReady}' +
        ' {uid: $uid} {selectedAnswer: $selectedAnswer} {commandHash: $commandHash}' +
    '{score $score}';
  }

  @override
  bool operator ==(Object other) =>
      false;

  @override
  int get hashCode => this.hashCode;
}