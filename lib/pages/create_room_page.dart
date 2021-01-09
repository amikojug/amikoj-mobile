import 'package:amikoj/components/app_bar.dart';
import 'package:amikoj/constants/room_action_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:amikoj/components/pill_button.dart';
import 'package:amikoj/components/pill_input.dart';
import 'package:amikoj/constants/constants.dart';

class CreateRoomPage extends StatefulWidget {
  @override
  _CreateRoomPageState createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  final roomNameTextController = TextEditingController();

  String roomName = "";
  String error = '';
  bool isValid = false;

  @override
  void initState() {
    super.initState();

    roomNameTextController.addListener(() {
      valid();
      setState(() {
        roomName = roomNameTextController.text;
      });
    });
  }

  void valid() async {
    List<String> roomsNames = [];
    await getData().then((value) => {
          value.forEach((val) {
            print(val);
            roomsNames.add(val);
          })
        });
    if (roomsNames.contains(roomName)) {
      setState(() {
        isValid = false;
        error = 'This room already exist';
      });
    } else if (roomName.isEmpty) {
      setState(() {
        isValid = false;
        error = 'Room name cannot be empty';
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
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
                            Text(
                              error,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: _width * 0.05,
                              ),
                            ),
                            SizedBox(height: _height * 0.03),
                            PillInput(
                              "Room Name",
                              roomNameTextController,
                            ),
                            Spacer(),
                            PillButton(
                              "Create room",
                              action: valid,
                              valid: isValid,
                              redirect: "/room",
                              redirectArgument: {
                                "type": RoomAction.create,
                                "roomName": roomNameTextController.text
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
}
