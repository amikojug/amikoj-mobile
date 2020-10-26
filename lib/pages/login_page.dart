import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

import 'package:amikoj/components/pill_button.dart';
import 'package:amikoj/components/pill_input.dart';

import '../constants/constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  String loginText = "";
  String passwordText = "";
  bool isKeyboardOpened = false;

  @override
  void initState() {
    super.initState();

    loginTextController.addListener(() {
      setState(() {
        loginText = loginTextController.text;
      });
    });

    passwordTextController.addListener(() {
      setState(() {
        passwordText = passwordTextController.text;
      });
    });

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          isKeyboardOpened = visible;
        });
      },
    );
  }

  bool isInputValid() {
    return loginText.isNotEmpty && passwordText.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          children: <Widget>[
            SvgPicture.asset('assets/images/background.svg', fit: BoxFit.cover,),
            Center(
              child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: isKeyboardOpened ? MainAxisAlignment.spaceBetween : MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Spacer(),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Spacer(flex: 2,),
                            PillInput("Username", loginTextController),
                            Spacer(),
                            PillInput("Password", passwordTextController),
                            Spacer(),
                            Shimmer.fromColors(
                              enabled: isInputValid(),
                              baseColor: Colors.white,
                              highlightColor: Color(0x22FFFFFF),
                              child: PillButton("Log in"),
                            ),
                            Spacer(),
                            if (!isKeyboardOpened)
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(context, '/');
                                          },
                                          child: Text("Back",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(context, '/home');
                                          },
                                          child: Text("Play as guest",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text("Or connect with:",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                          icon: FaIcon(FontAwesomeIcons.facebookSquare, color: Colors.white, size: 40,),
                                          onPressed: () { print("Pressed"); }
                                      ),
                                      IconButton(
                                        // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                          icon: FaIcon(FontAwesomeIcons.instagramSquare, color: Colors.white, size: 40,),
                                          onPressed: () { print("Pressed"); }
                                      ),
                                      IconButton(
                                        // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                          icon: FaIcon(FontAwesomeIcons.googlePlusSquare, color: Colors.white, size: 40,),
                                          onPressed: () { print("Pressed"); }
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            Spacer()
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