import 'package:amikoj/components/loading.dart';
import 'package:amikoj/models/user_module.dart';
import 'package:amikoj/redux/app_state.dart';
import 'package:amikoj/redux/user_reducer.dart';
import 'package:amikoj/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:amikoj/services/auth.dart';
import 'package:amikoj/components/pill_button.dart';
import 'package:amikoj/components/pill_input.dart';

import '../constants/constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  final loginTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  String loginText = "";
  String passwordText = "";
  String error = '';
  bool loading = false;

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
  }

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: backgroundColor,
            body: Stack(
              children: <Widget>[
                SvgPicture.asset(
                  'assets/images/background.svg',
                  fit: BoxFit.cover,
                ),
                Center(
                  child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: _keyboardIsVisible()
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          // Spacer(flex: 1),
                          !_keyboardIsVisible() ? SizedBox(height: _height*0.42) : SizedBox(height: _height*0.2,),
                          Expanded(
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  error,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: _width*0.05,
                                  ),
                                ),
                                Spacer(
                                  flex: 2,
                                ),
                                PillInput("Email", loginTextController),
                                Spacer(),
                                PillInput("Password", passwordTextController,
                                    obscureText: true),
                                Spacer(),
                                Shimmer.fromColors(
                                  enabled: isInputValid(),
                                  baseColor: Colors.white,
                                  highlightColor: Color(0x22FFFFFF),
                                  child:
                                      PillButton("Log in", action: () async {
                                    setState(() {
                                      loading = true;
                                    });
                                    dynamic result = await _auth
                                        .signInWithEmailAndPassword(
                                            this.loginText,
                                            this.passwordText);
                                    if (result == null) {
                                      print(result);
                                      setState(() {
                                        error =
                                            'Could  not sign in with those credentials';
                                        loading = false;
                                      });
                                    } else {
                                      Navigator.pushNamed(context, '/home');
                                    }
                                  }),
                                ),
                                Spacer(),
                                if (!_keyboardIsVisible())
                                  otherConnections(),
                                Spacer()
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

  Widget otherConnections() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Column(
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
                      context, '/');
                },
                child: Text(
                  "Back",
                  style: TextStyle(
                    fontSize: _width*0.06,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                      context, '/register');
                },
                child: Text(
                  "Register",
                  style: TextStyle(
                    fontSize: _width*0.06,
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
              fontSize: _width*0.06,
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
              // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                icon: FaIcon(
                  FontAwesomeIcons
                      .facebookSquare,
                  color: Colors.white,
                  size: _width*0.1,
                ),
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  UserModule result = await _auth.signInWithFacebook();
                  print('------------------result');
                  print(result);
                  if (result == null) {
                    print('error signing in');
                    setState(() {
                      error =
                      'Could  not sign in with those credentials';
                      loading = false;
                    });
                  } else {
                    print('signed in');
                    String avatarUrl = await downloadUserAvatar(result.uid);
                    if (avatarUrl != null) {
                      StoreProvider.of<AppState>(context)
                          .dispatch(UpdateUser(avatarUrl: avatarUrl));
                    }
                    setState(() {
                      loading = false;
                    });
                    Navigator.pushNamed(context, '/home');
                  }
                }),
            // IconButton(
            //   // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
            //     icon: FaIcon(
            //       FontAwesomeIcons
            //           .instagramSquare,
            //       color: Colors.white,
            //       size: 40,
            //     ),
            //     onPressed: () {
            //       print("Pressed");
            //     }),
            IconButton(
              // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                icon: FaIcon(
                  FontAwesomeIcons
                      .googlePlusSquare,
                  color: Colors.white,
                  size: _width*0.1,
                ),
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  dynamic result = await _auth
                      .loginWithGoogle();

                  if (result == null) {
                    print(result);
                    setState(() {
                      error =
                      'Could  not sign in with those credentials';
                      loading = false;
                    });
                  } else {
                    Navigator.pushNamed(
                        context, '/home');
                  }
                }),
          ],
        ),
      ],
    );
  }

  bool _keyboardIsVisible() {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }

  bool isInputValid() {
    return loginText.isNotEmpty && passwordText.isNotEmpty;
  }
}
