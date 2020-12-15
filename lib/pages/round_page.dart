import 'package:amikoj/components/app_bar.dart';
import 'package:amikoj/redux/room_state.dart';
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
  @override
  Widget build(BuildContext context) {
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
                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                      child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(36.0),
                                              border: Border.all(
                                                  color: Colors.white, width: 4),
                                              color: Color(0x55000000)),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                    child: Text(
                                                      state.roomName,
                                                      style: TextStyle(
                                                        fontSize: 20.0,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w500,
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
                                                  Flexible(
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.symmetric(
                                                          vertical: 10),
                                                      child: Text(
                                                        "W środku nocy budzi Cię głośna muzyka dobiegająca z mieszkania sąsiada. Co robisz?",
                                                        style: whiteText,
                                                        textAlign: TextAlign.center,
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
                                              Expanded(
                                                child: ListView(children: getAnswerCards(),),
                                              )
                                            ],
                                          )),
                                    )),
                                Spacer(),
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
        }
    );
  }

  Widget answerCard(String answer) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(360),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: FlatButton(
          onPressed: () {
            print("Asas");
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
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      child: Text(
                          answer,
                          textAlign: TextAlign.center,
                          style: whiteText),
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

  List<Widget> getAnswerCards() {
    List<Widget> widgets = ["asasasd saaaaaaaaaaaaa sssssssssssssss sssssssssssssssssssssss ssssssssssss sssssssssss ssssssssssss sssssssssssss sssssssssssssq", "dfewsadasd asdasdasdasda  asda dasd asdasdasdasdasdasda asdasdasdasdasdas sajhabjsb ajshbajshba sjhasbjahsb", "wqweqweq"]
        .map((answer) => answerCard(answer)).toList();
    return widgets;
  }
}