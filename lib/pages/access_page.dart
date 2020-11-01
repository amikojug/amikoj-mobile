import 'package:amikoj/components/user_module.dart';
import 'package:amikoj/redux/app_state.dart';
import 'package:amikoj/redux/user_reducer.dart';
import 'package:amikoj/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:amikoj/services/auth.dart';
import 'package:amikoj/components/pill_button.dart';
import '../constants/constants.dart';

class AccessPage extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            "Play as guest",
                            action: () async {
                              UserModule result = await _auth.signInAnon();
                              if (result == null) {
                                print('error signing in');
                              } else {
                                print('signed in');
                                String avatarUrl = await downloadUserAvatar(result.uid);
                                if (avatarUrl != null) {
                                  StoreProvider.of<AppState>(context)
                                      .dispatch(UpdateUser(avatarUrl: avatarUrl));
                                }
                                Navigator.pushNamed(context, '/home');
                              }
                            },
                          ),
                          Spacer(),
                          PillButton(
                            "Login",
                            redirect: "/login",
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
