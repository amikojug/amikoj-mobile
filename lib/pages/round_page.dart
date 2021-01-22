import 'dart:async';

import 'package:amikoj/components/app_bar.dart';
import 'package:amikoj/components/pill_button.dart';
import 'package:amikoj/components/timer.dart';
import 'package:amikoj/models/user_module.dart';
import 'package:amikoj/redux/room_state.dart';
import 'package:amikoj/redux/user_state.dart';
import 'package:amikoj/services/realtime_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:amikoj/redux/app_state.dart';
import 'package:amikoj/redux/user_reducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:amikoj/services/auth.dart';
import '../constants/constants.dart';
import 'package:amikoj/services/commandExecutor.dart';

class RoundPage extends StatefulWidget {
  @override
  _RoundPageState createState() => _RoundPageState();
}

TimerController timerController = new TimerController();

final AuthService _auth = AuthService();

TimerController getTimerController() {
  return timerController;
}

class _RoundPageState extends State<RoundPage> {
  AuthService _authService = new AuthService();

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          Color frameColor =
              isAskedPlayer(state.roomState) ? Colors.yellow : Colors.white;
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
                          Expanded(
                            flex: 6,
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: CountDownTimer(
                                    size: (_height * 0.13).toInt(),
                                    onFinish: () {
                                      updateAnswerAfterTimesUp(context);
                                    },
                                    timerController: timerController,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    getTextAboutAskedPlayer(),
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
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
                                                  color: frameColor, width: 4),
                                              color: Color(0x77000000)),
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
                                                      state.roomState.roomName,
                                                      style: TextStyle(
                                                        fontSize: 20.0,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Divider(
                                                color: frameColor,
                                                thickness: 4,
                                                height: 0,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Flexible(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 20.0,
                                                          horizontal: 15.0),
                                                      child: Text(
                                                        getQuestions()[
                                                                getQuestionNumber(
                                                                    state
                                                                        .roomState)]
                                                            ['question'],
                                                        style: whiteText,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Divider(
                                                color: frameColor,
                                                thickness: 4,
                                                height: 0,
                                              ),
                                              Expanded(
                                                // child: Padding(
                                                //   padding:
                                                //       const EdgeInsets.all(8.0),
                                                child: ListView(
                                                    children: getAnswerCards(
                                                        context,
                                                        state.userState,
                                                        state.roomState)),
                                                // ),
                                              )
                                            ],
                                          )),
                                    )),
                                Spacer(),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          );
        });
  }

  String getPlayerName(String id, RoomState roomState) {
    return roomState.players.where((player) => player.uid == id).first.name;
  }

  String getTextAboutAskedPlayer() {
    RoomState roomState = StoreProvider.of<AppState>(context).state.roomState;
    if (roomState.askedPlayer != _auth.getCurrentUser().uid) {
      return 'Question about ' +
          getPlayerName(roomState.askedPlayer, roomState);
    } else {
      return '';
    }
  }

  void updateAnswerAfterTimesUp(BuildContext context) {
    List<UserModule> players =
        StoreProvider.of<AppState>(context).state.roomState.players;
    var userId = _auth.getCurrentUser().uid;
    dynamic selectedAnswer =
        players.where((element) => element.uid == userId).first.selectedAnswer;
    if (selectedAnswer == null) {
      StoreProvider.of<AppState>(context)
          .dispatch(UpdateUserSelectedAnswer(selectedAnswer: 'NONE'));
      updateYourselfInTheRoom();
    }
  }

  bool isAskedPlayer(RoomState roomState) {
    return _authService.getCurrentUser().uid == roomState.askedPlayer;
  }

  Widget answerCard(
      String key, String answer, BuildContext ctx, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Color(0xAA000000) : null,
          borderRadius: BorderRadius.circular(360),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: FlatButton(
          onPressed: () {
            StoreProvider.of<AppState>(ctx)
                .dispatch(UpdateUserSelectedAnswer(selectedAnswer: key));
            updateYourselfInTheRoom();
            getTimerController().stopTimer();
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(360.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 44),
                  child: Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      child: Text(answer,
                          textAlign: TextAlign.center, style: whiteText),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  int getQuestionNumber(RoomState roomState) {
    try {
      return int.parse(roomState.currentQuestionId);
    } catch (e) {
      return 0;
    }
  }

  List<Widget> getAnswerCards(
      BuildContext ctx, UserState userState, RoomState roomState) {
    List<Widget> widgets = [];
    getQuestions()[getQuestionNumber(roomState)]['answers'].forEach(
        (key, value) => widgets
            .add(answerCard(key, value, ctx, userState.selectedAnswer == key)));
    return widgets;
  }
}
