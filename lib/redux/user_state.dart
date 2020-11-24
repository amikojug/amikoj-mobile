import 'package:meta/meta.dart';

@immutable
class UserState {
  final String uid;
  final String avatarUrl;
  final String name;
  final bool isReady;

  UserState({@required this.uid, @required this.avatarUrl, @required this.name, @required this.isReady});

  UserState.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        avatarUrl = json['avatarUrl'],
        isReady = json['isReady'],
        uid = json['uid'];

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'avatarUrl': avatarUrl,
        'isReady': isReady,
        'uid': uid,
      };

  static UserState initial() {
    return new UserState(
        avatarUrl: "https://images.pexels.com/photos/1252869/pexels-photo-1252869.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
        name: "Best name",
        isReady: false,
        uid: "",
    );
  }

  @override
  String toString() {
    return 'UserState: {avatarUrl: $avatarUrl} {name: $name} {isReady: $isReady} {uid: $uid}';
  }

  @override
  bool operator ==(Object other) =>
      false;

  @override
  int get hashCode => this.hashCode;
}