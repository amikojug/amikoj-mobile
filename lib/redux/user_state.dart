import 'package:meta/meta.dart';

@immutable
class UserState {
  final String avatarUrl;

  UserState({@required this.avatarUrl});

  static UserState initial() {
    return new UserState(avatarUrl: "https://images.pexels.com/photos/1252869/pexels-photo-1252869.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500");
  }

  @override
  String toString() {
    return 'UserState: {avatarUrl: $avatarUrl}';
  }

  @override
  bool operator ==(Object other) =>
      false;

  @override
  int get hashCode => this.hashCode;
}