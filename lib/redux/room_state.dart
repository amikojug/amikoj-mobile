import 'package:amikoj/models/user_module.dart';
import 'package:meta/meta.dart';

@immutable
class RoomState {
  final List<UserModule> players;
  final String roomName;
  final String hostId;
  final String currentQuestionId;

  RoomState({
    @required this.players,
    @required this.roomName,
    @required this.hostId,
    @required this.currentQuestionId
  });

  RoomState.fromJson(Map<String, dynamic> json)
    : players = json['players'],
      roomName = json['roomName'],
      hostId = json['hostId'],
      currentQuestionId = json['currentQuestionId'];

  Map<String, dynamic> toJson() =>
      {
        'players': players,
        'roomName': roomName,
        'hostId': hostId,
        'currentQuestionId': currentQuestionId,
      };

  static RoomState initial() {
    return new RoomState(
        players: new List(),
        roomName: "",
        hostId: "",
        currentQuestionId: '0'
    );
  }

  @override
  String toString() {
    return 'RoomState: {avatarUrl: $players} {roomName: $roomName} {hostId: $hostId} {currentQuestionId: $currentQuestionId}';
  }

  @override
  bool operator ==(Object other) =>
      false;

  @override
  int get hashCode => this.hashCode;
}