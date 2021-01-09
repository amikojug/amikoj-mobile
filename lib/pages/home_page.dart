import 'package:amikoj/components/app_bar.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:amikoj/components/pill_button.dart';

import '../constants/constants.dart';

class HomePage extends StatelessWidget {
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
                          PillButton(
                            "Create room",
                            valid: true,
                            redirect: "/createRoom",
                          ),
                          Spacer(),
                          PillButton(
                            "Join room",
                            valid: true,
                            redirect: "/joinRoom",
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
