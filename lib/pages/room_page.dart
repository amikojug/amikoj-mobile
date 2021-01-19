import 'dart:convert';

import 'package:amikoj/components/app_bar.dart';
import 'package:amikoj/models/user_module.dart';
import 'package:amikoj/constants/room_action_type.dart';
import 'package:amikoj/redux/app_state.dart';
import 'package:amikoj/redux/room_reducer.dart';
import 'package:amikoj/redux/room_state.dart';
import 'package:amikoj/redux/user_reducer.dart';
import 'package:amikoj/services/realtime_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:amikoj/components/pill_button.dart';
import 'package:amikoj/constants/constants.dart';
import 'package:amikoj/components/player_grid.dart';
import 'package:amikoj/services/auth.dart';
import 'package:amikoj/app.dart';
import 'package:redux/redux.dart';
import 'package:shimmer/shimmer.dart';

class RoomPage extends StatefulWidget {
  @override
  _RoomPage createState() => _RoomPage();
}

class _RoomPage extends State<RoomPage> {
  final AuthService _auth = AuthService();
  String error = '';

  void _createOrJoinRoom(BuildContext context) {
    Map<String, dynamic> routeArgs = ModalRoute.of(context).settings.arguments;
    if (routeArgs["type"] == RoomAction.create) {
      initRoom(routeArgs["roomName"]);
      changeQuestion(context);
    } else if (routeArgs["type"] == RoomAction.join) {
      addYourselfToTheRoom(routeArgs["roomName"]);
    }
    updateYourselfInTheRoom();
  }

  void _createRoomSubscription(BuildContext context) {
    Map<String, dynamic> routeArgs = ModalRoute.of(context).settings.arguments;
    print(routeArgs);
    String roomName = routeArgs["roomName"];
    createRoomSubscription(roomName, context);
    _createOrJoinRoom(context);
  }

  @override
  Widget build(BuildContext context) {
    _createRoomSubscription(context);
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return StoreConnector<AppState, RoomState>(
        converter: (store) => store.state.roomState,
        builder: (context, state) {
          return Scaffold(
            appBar: AmikojAppBar(context),
            backgroundColor: backgroundColor,
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                SvgPicture.asset(
                  'assets/images/background_without_logo.svg',
                  fit: BoxFit.cover,
                ),
                Center(
                  child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Spacer(
                            flex: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              error,
                              style: TextStyle(
                                fontSize: _width * 0.05,
                                fontWeight: FontWeight.w500,
                                // color: Colors.red,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                    flex: 10,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(36.0),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 4),
                                              color: Color(0xAA000000)),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 10),
                                                    child: Text(
                                                      state.roomName,
                                                      style: TextStyle(
                                                        fontSize: _width * 0.05,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Divider(
                                                color: Colors.white,
                                                thickness: 4,
                                                height: 0,
                                              ),
                                              PlayerGrid(),
                                            ],
                                          )),
                                    )),
                                Spacer(),
                                startOrReadyButton(
                                    context, state, _auth.getCurrentUser()),
                                Spacer(),
                                PillButton(
                                  "Leave",
                                  valid: true,
                                  redirect: "/home",
                                  action: () async {
                                    await removeYourselfFromRoom();
                                    StoreProvider.of<AppState>(context)
                                        .dispatch(ResetRoom());
                                  },
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ],
                      )),
                )
              ],
            ),
          );
        });
  }

  Widget startOrReadyButton(
      BuildContext ctx, RoomState roomState, UserModule player) {
    if (isHostPlayer(roomState, player)) {
      return Shimmer.fromColors(
        enabled: true,
        baseColor: Colors.white,
        highlightColor: Color(0x22FFFFFF),
        child: PillButton(
          "Start",
          action: () async {
            print('click');
            dynamic playersWithoutHost = [...roomState.players]
                .where((item) => item.uid != roomState.hostId);
            bool allReady =
                [...playersWithoutHost].every((item) => item.isReady);
            print(allReady);
            if ([...roomState.players].length >= 2) {
              if (allReady) {
                setState(() {
                  error = '';
                });
                sendRedirectToRoundPage(ctx);
              } else {
                setState(() {
                  error = 'Not every player is ready';
                });
              }
            } else {
              setState(() {
                error = 'You need more players';
              });
            }
          },
        ),
      );
    }
    return PillButton(
      "Ready",
      action: () async {
        StoreProvider.of<AppState>(ctx)
            .dispatch(UpdateUserReadiness(isReady: true));
        updateYourselfInTheRoom();
      },
    );
  }

  bool isHostPlayer(RoomState roomState, UserModule player) {
    return roomState.hostId == player.uid;
  }
}
