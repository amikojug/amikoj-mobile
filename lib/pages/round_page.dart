import 'dart:convert';

import 'package:amikoj/components/app_bar.dart';
import 'package:amikoj/redux/room_state.dart';
import 'package:amikoj/redux/user_state.dart';
import 'package:amikoj/services/realtime_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:amikoj/models/user_module.dart';
import 'package:amikoj/redux/app_state.dart';
import 'package:amikoj/redux/user_reducer.dart';
import 'package:amikoj/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:amikoj/services/auth.dart';
import 'package:amikoj/components/pill_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/constants.dart';

class RoundPage extends StatefulWidget {
  @override
  _RoundPageState createState() => _RoundPageState();
}

class _RoundPageState extends State<RoundPage> {
  AuthService _authService = new AuthService();
  @override
  Widget build(BuildContext context) {
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
                  'assets/images/background.svg',
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
                                                          vertical: 10),
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
                                                child: ListView(
                                                    children: getAnswerCards(
                                                        context,
                                                        state.userState,
                                                        state.roomState)),
                                              )
                                            ],
                                          )),
                                    )),
                                Spacer(),
                                PillButton(
                                  "Next Question",
                                  action: () {
                                    print("KKK1");
                                    changeQuestion(context);
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

  bool isAskedPlayer(RoomState roomState) {
    return _authService.getCurrentUser().uid == roomState.askedPlayer;
  }

  Widget answerCard(
      String key, String answer, BuildContext ctx, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Color(0xAA440044) : null,
          borderRadius: BorderRadius.circular(360),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: FlatButton(
          onPressed: () {
            StoreProvider.of<AppState>(ctx)
                .dispatch(UpdateUserSelectedAnswer(selectedAnswer: key));
            updateYourselfInTheRoom();
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
