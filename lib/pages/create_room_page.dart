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

  @override
  void initState() {
    super.initState();

    roomNameTextController.addListener(() {
      setState(() {
        roomName = roomNameTextController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: backgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            SvgPicture.asset('assets/images/background.svg', fit: BoxFit.cover,),
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
                            Spacer(flex: 3,),
                            PillInput("Room Name", roomNameTextController),
                            Spacer(),
                            PillButton("Create room", redirect: "/room",),
                            Spacer(),
                            PillButton("Back", redirect: "/home",),
                            Spacer(flex: 3,),
                          ],
                        ),
                      ),
                    ],
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}