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

  @override
  void initState() {
    super.initState();

    roomIdTextController.addListener(() {
      setState(() {
        roomId = roomIdTextController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                          PillInput("Room ID", roomIdTextController),
                          Spacer(),
                          PillButton("Join room",
                            redirect: "/room",
                            redirectArgument: {
                              "type": RoomAction.join,
                              "roomName": roomIdTextController.text
                            },
                          ),
                          Spacer(),
                          PillButton("Back",
                            redirect: "/home",
                          ),
                          Spacer(flex: 3,),
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
