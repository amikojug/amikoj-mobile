import 'package:amikoj/components/app_bar.dart';
import 'package:amikoj/constants/room_action_type.dart';
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
      setState(() {
        roomName = roomNameTextController.text;
      });
    });
  }

  void valid() {
    print('funkcja walidacji');
    if (roomName.isNotEmpty) {
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

  // List<String> getData() {
  //   List<String> roomsNames = [];
  //   final databaseReference =
  //       FirebaseDatabase.instance.reference().child('rooms');

  //   databaseReference.once().then((DataSnapshot snapshot) {
  //     print(snapshot.value);
  //   });

  // Stream<QuerySnapshot> productRef =
  //     FirebaseFirestore.instance.collection("rooms").snapshots();
  // print('--------------------------');
  // print(productRef);
  // productRef.forEach((field) {
  //   print('-----');
  //   print(field.docs.asMap());
  //   field.docs.asMap().forEach((index, data) {
  //     // print(field.docs[index]);
  //     // roomsNames.add(field.docs[index][]);
  //   });
  // });
  // print(roomsNames);
  // }
}
