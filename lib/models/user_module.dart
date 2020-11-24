class UserModule {
  final String uid;
  String avatarUrl;
  String name = "Best Name";
  bool isReady = false;

  UserModule({this.uid, this.avatarUrl, this.name, this.isReady});

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'uid': uid,
        'avatarUrl': avatarUrl,
        'isReady': isReady,
      };
}

UserModule fromJson(Map<String, dynamic> json) {
  return new UserModule(
      uid: json["uid"],
      avatarUrl: json["avatarUrl"],
      name: json["name"],
      isReady: json["isReady"],
  );
}

List<UserModule> usersFromJson(Map<String, dynamic> json) {
  List<UserModule> results = new List();
  List<dynamic> players = json["players"] == null ? [] : json["players"];
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
