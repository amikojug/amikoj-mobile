import 'package:amikoj/components/loading.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  final AuthService _auth = AuthService();

  String loginText = "";
  String passwordText = "";
  String confirmPasswordText = "";
  bool isKeyboardOpened = false;
  bool loading = false;
  String error = '';

  bool validEmail(email) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(email);
  }

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

  void valid() async {
    print('register');
    print(_formKey.currentState.validate());
    if (_formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      dynamic result = await _auth.registerWithEmailAndPassword(
          this.loginText, this.passwordText);
      if (result == null) {
        setState(() => {
              error = 'please supply a valid email',
              loading = false,
            });
      } else {
        Navigator.pushNamed(context, '/login');
      }
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
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
                            !_keyboardIsVisible() ? Spacer(flex: 3) : SizedBox(height: _height*0.17),
                            Expanded(
                              flex: 4,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Spacer(
                                    flex: 1,
                                  ),
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisAlignment: isKeyboardOpened
                                          ? MainAxisAlignment.spaceBetween
                                          : MainAxisAlignment.spaceAround,
                                      children: [
                                        PillInput(
                                          "Email",
                                          loginTextController,
                                          validator: (val) {
                                            print('email ' + val);
                                            if (val.isEmpty) {
                                              return 'Enter email';
                                            } else if (!validEmail(
                                                loginTextController.text)) {
                                              return 'invalid email format';
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),

                                        SizedBox(height: 6.0),
                                        // Spacer(),
                                        PillInput(
                                            "Password", passwordTextController,
                                            validator: (val) {
                                          if (val.length <= 6) {
                                            return 'Enter a password 6+ chars long';
                                          } else {
                                            return null;
                                          }
                                        }, obscureText: true),
                                        SizedBox(height: 6.0),
                                        // Spacer(),
                                        PillInput(
                                          "Confirm Password",
                                          confirmPasswordTextController,
                                          obscureText: true,
                                          validator: (val) {
                                            if (val.length == 0) {
                                              return 'Please confirm password';
                                            } else if (val !=
                                                passwordTextController.text) {
                                              return 'incorrect password';
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        SizedBox(height: 6.0),
                                        // Spacer(),
                                        Shimmer.fromColors(
                                          enabled: isInputValid(),
                                          baseColor: Colors.white,
                                          highlightColor: Color(0x22FFFFFF),
                                          child: PillButton(
                                            "Register",
                                            action: valid,
                                          ),
                                        ),
                                      ],
                                    ),
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
                                            ],
                                          ),
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

  bool _keyboardIsVisible() {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }
}
