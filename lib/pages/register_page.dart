import 'package:amikoj/pages/loading.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:amikoj/components/pill_button.dart';
import 'package:amikoj/components/pill_input.dart';
import 'package:amikoj/services/auth.dart';

import '../constants/constants.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final loginTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  String loginText = "";
  String passwordText = "";
  String confirmPasswordText = "";
  bool isKeyboardOpened = false;
  bool loading = false;
  String error = '';

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

    confirmPasswordTextController.addListener(() {
      setState(() {
        confirmPasswordText = confirmPasswordTextController.text;
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
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: backgroundColor,
            body: new GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Stack(
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/images/background.svg',
                    fit: BoxFit.cover,
                  ),
                  Center(
                    child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: isKeyboardOpened
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Spacer(
                              flex: 2,
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Spacer(
                                    flex: 1,
                                  ),
                                  PillInput("Email", loginTextController),
                                  Spacer(),
                                  PillInput("Password", passwordTextController,
                                      obscureText: true),
                                  Spacer(),
                                  PillInput("Confirm Password",
                                      confirmPasswordTextController,
                                      obscureText: true),
                                  Spacer(),
                                  Shimmer.fromColors(
                                    enabled: isInputValid(),
                                    baseColor: Colors.white,
                                    highlightColor: Color(0x22FFFFFF),
                                    child: PillButton("Register",
                                        action: () async {
                                      setState(() {
                                        loading = true;
                                      });
                                      dynamic result = await _auth
                                          .registerWithEmailAndPassword(
                                              this.loginText,
                                              this.passwordText);
                                      if (result == null) {
                                        setState(() => {
                                              error =
                                                  'please supply a valid email',
                                              loading = false,
                                            });
                                        Navigator.pushNamed(context, '/login');
                                      }
                                    }),
                                  ),
                                  Spacer(),
                                  if (!isKeyboardOpened)
                                    Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                      context, '/login');
                                                },
                                                child: Text(
                                                  "Back",
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                      context, '/login');
                                                },
                                                child: Text(
                                                  "Play as guest",
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
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            "Or connect with:",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                                icon: FaIcon(
                                                  FontAwesomeIcons
                                                      .facebookSquare,
                                                  color: Colors.white,
                                                  size: 40,
                                                ),
                                                onPressed: () {
                                                  print("Pressed");
                                                }),
                                            IconButton(
                                                icon: FaIcon(
                                                  FontAwesomeIcons
                                                      .instagramSquare,
                                                  color: Colors.white,
                                                  size: 40,
                                                ),
                                                onPressed: () {
                                                  print("Pressed");
                                                }),
                                            IconButton(
                                                icon: FaIcon(
                                                  FontAwesomeIcons
                                                      .googlePlusSquare,
                                                  color: Colors.white,
                                                  size: 40,
                                                ),
                                                onPressed: () {
                                                  print("Pressed");
                                                }),
                                          ],
                                        ),
                                      ],
                                    ),
                                  Spacer()
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
}