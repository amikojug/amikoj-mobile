class UserModule {
  final String uid;
  String avatarUrl;

  UserModule({this.uid, this.avatarUrl});
}

UserModule fromJson(Map<String, dynamic> json) {
  return new UserModule(
      uid: json["playerId"],
      avatarUrl: json["avatarUrl"]
  );
}

List<UserModule> usersFromJson(Map<String, dynamic> json) {
  List<UserModule> results = new List();
  List<dynamic> players = json["players"];
  players.forEach((element) {
    results.add(fromJson(Map<String, dynamic>.from(element)));
  });
  return results;
}

class UserData {
  final String uid;
  final String name;
  final String sugars;
  final int strength;

  UserData({this.uid, this.name, this.sugars, this.strength});
}
