import 'package:amikoj/components/app_bar.dart';
import 'package:amikoj/components/pill_input.dart';
import 'package:amikoj/constants/room_action_type.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:amikoj/components/pill_button.dart';

import '../constants/constants.dart';

class JoinRoomPage extends StatefulWidget {
  @override
  _JoinRoomPageState createState() => _JoinRoomPageState();
}

class _JoinRoomPageState extends State<JoinRoomPage> {
  final roomIdTextController = TextEditingController();

  String roomId = "";
  String error = '';
  bool isValid = false;

  @override
  void initState() {
    super.initState();

    roomIdTextController.addListener(() {
      setState(() {
        roomId = roomIdTextController.text;
      });
    });
  }

  void valid() {
    print('funkcja walidacji');
    if (roomId.isNotEmpty) {
      setState(() {
        isValid = true;
      });
    } else {
      setState(() {
        error = 'Room name cannot be empty';
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
                          Text(
                            error,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: _width * 0.05,
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
}
