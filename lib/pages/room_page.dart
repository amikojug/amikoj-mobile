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

class RoomPage extends StatelessWidget {
  final AuthService _auth = AuthService();

  void _createOrJoinRoom(BuildContext context) {
    Map<String, dynamic> routeArgs = ModalRoute.of(context).settings.arguments;
    if (routeArgs["type"] == RoomAction.create) {
      initRoom(routeArgs["roomName"]);
    } else if (routeArgs["type"] == RoomAction.join) {
      addYourselfToTheRoom(routeArgs["roomName"]);
    }
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
                  'assets/images/background.svg',
                  fit: BoxFit.cover,
                ),
                Center(
                  child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Spacer(
                            flex: 2,
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
                                              color: Color(0x55000000)),
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
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 10),
                                                    child: Text(
                                                      "PIN: 123456",
                                                      style: whiteText,
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
                                  redirect: "/home",
                                  action: () async {
                                    removeYourselfFromRoom();
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
          redirect: "/round",
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
