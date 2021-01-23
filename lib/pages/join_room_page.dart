import 'package:amikoj/app.dart';
import 'package:amikoj/components/app_bar.dart';
import 'package:amikoj/components/pill_input.dart';
import 'package:amikoj/constants/room_action_type.dart';
import 'package:amikoj/redux/app_state.dart';
import 'package:amikoj/services/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:redux/redux.dart';

import 'package:amikoj/components/pill_button.dart';

import '../constants/constants.dart';

class JoinRoomPage extends StatefulWidget {
  @override
  _JoinRoomPageState createState() => _JoinRoomPageState();
}

class _JoinRoomPageState extends State<JoinRoomPage> {
  final roomIdTextController = TextEditingController();
  Store<AppState> s = getStore();

  String roomId = "";
  String error = '';
  bool isValid = false;

  @override
  void initState() {
    super.initState();

    roomIdTextController.addListener(() {
      valid();
      setState(() {
        roomId = roomIdTextController.text;
      });
    });
  }

  void valid() async {
    List<String> roomsNames = [];
    String name = s.state.userState.name;
    await getData().then((value) => {
          value.forEach((val) {
            print(val);
            roomsNames.add(val);
          })
        });
    List<String> playersInRoom = await getPlayers(roomId);
    if (roomId.isEmpty) {
      setState(() {
        isValid = false;
        error = 'Room name cannot be empty';
      });
    } else if (!roomsNames.contains(roomId)) {
      setState(() {
        isValid = false;
        error = "This room don't exist";
      });
    } else if (playersInRoom.contains(name)) {
      setState(() {
        isValid = false;
        error = "This room already contains a player with the same name";
      });
    } else {
      setState(() {
        isValid = true;
        error = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AmikojAppBar(context),
      backgroundColor: backgroundColor,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          SvgPicture.asset(
            'assets/images/background.svg',
            fit: BoxFit.cover,
          ),
          Center(
            child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Spacer(),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Spacer(
                            flex: 3,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                error,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: _width * 0.05,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(height: _height * 0.03),
                          PillInput("Room Name", roomIdTextController),
                          Spacer(),
                          PillButton(
                            "Join room",
                            valid: isValid,
                            action: valid,
                            redirect: "/room",
                            redirectArgument: {
                              "type": RoomAction.join,
                              "roomName": roomIdTextController.text
                            },
                          ),
                          Spacer(),
                          PillButton(
                            "Back",
                            valid: true,
                            redirect: "/home",
                          ),
                          Spacer(
                            flex: 3,
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }

  Future getData() async {
    List<String> roomsNames = [];

    final databaseReference =
        FirebaseDatabase.instance.reference().child('rooms');

    await databaseReference.once().then((DataSnapshot snapshot) {
      snapshot.value.keys.forEach((item) {
        roomsNames.add(item);
      });
    });

    return roomsNames;
  }

  Future getPlayers(roomName) async {
    List<String> playersInRoom = [];

    final databaseReference = FirebaseDatabase.instance
        .reference()
        .child('rooms')
        .child(roomName)
        .child('players');

    await databaseReference.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null)
        snapshot.value.forEach((item) => playersInRoom.add(item['name']));
    });

    return playersInRoom;
  }
}
