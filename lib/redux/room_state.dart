import 'package:meta/meta.dart';

@immutable
class RoomState {
  final List<String> players;

  RoomState({@required this.players});

  static RoomState initial() {
    return new RoomState(players: new List());
  }

  @override
  String toString() {
    return 'RoomState: {avatarUrl: $players}';
  }

  @override
  bool operator ==(Object other) =>
      false;

  @override
  int get hashCode => this.hashCode;
}