import 'package:amikoj/models/user_module.dart';
import 'package:meta/meta.dart';

@immutable
class RoomState {
  final List<UserModule> players;
  final String roomName;
  final String hostId;
  final String currentQuestionId;
  final String askedPlayer;

  RoomState({
    @required this.players,
    @required this.roomName,
    @required this.hostId,
    @required this.currentQuestionId,
    @required this.askedPlayer
  });

  RoomState.fromJson(Map<String, dynamic> json)
    : players = json['players'],
      roomName = json['roomName'],
      hostId = json['hostId'],
      currentQuestionId = json['currentQuestionId'],
      askedPlayer= json['askedPlayer'];

  Map<String, dynamic> toJson() =>
      {
        'players': players,
        'roomName': roomName,
        'hostId': hostId,
        'currentQuestionId': currentQuestionId,
        'askedPlayer': askedPlayer
      };

  static RoomState initial() {
    return new RoomState(
        players: new List(),
        roomName: "",
        hostId: "",
        currentQuestionId: '0',
        askedPlayer: ""
    );
  }

  @override
  String toString() {
    return 'RoomState: {avatarUrl: $players} {roomName: $roomName} ' +
        '{hostId: $hostId} {currentQuestionId: $currentQuestionId}' +
        '{askedPlayer: $askedPlayer}'
    ;
  }

  @override
  bool operator ==(Object other) =>
      false;

  @override
  int get hashCode => this.hashCode;
}