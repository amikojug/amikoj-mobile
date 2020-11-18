import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../constants/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          SvgPicture.asset(
            'assets/images/background.svg',
            fit: BoxFit.cover,
          ),
          Center(
            child: Container(
              child: Center(
                child: SpinKitRing(
                  color: Colors.white,
                  size: 50.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
