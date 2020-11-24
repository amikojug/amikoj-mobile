import 'package:amikoj/models/user_module.dart';
import 'package:meta/meta.dart';

@immutable
class RoomState {
  final List<UserModule> players;
  final String roomName;
  final String hostId;

  RoomState({@required this.players, @required this.roomName, @required this.hostId});

  static RoomState initial() {
    return new RoomState(players: new List(), roomName: "", hostId: "");
  }

  @override
  String toString() {
    return 'RoomState: {avatarUrl: $players} {roomName: $roomName} {hostId: $hostId}';
  }

  @override
  bool operator ==(Object other) =>
      false;

  @override
  int get hashCode => this.hashCode;
}