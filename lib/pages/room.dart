import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:amikoj/components/pill_button.dart';
import 'package:amikoj/constants/constants.dart';
import 'package:amikoj/components/player_grid.dart';

class RoomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFBB81F6),
        actions: [
          FlatButton(
            color: Colors.transparent,
            onPressed: () { Navigator.pushNamed(context, '/account'); },
            child: Row(
              children: [
                Text("Best name", style: whiteText,),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Container(
                      width: 44.0,
                      height: double.infinity,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage(
                                  "https://i.imgur.com/BoN9kdC.png")
                          )
                      )),
                ),
              ],
            ),
          )
        ],
      ),
      backgroundColor: backgroundColor,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          SvgPicture.asset('assets/images/background.svg', fit: BoxFit.cover,),
          Center(
            child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Spacer(flex: 2,),
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 10,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(36.0),
                                    border: Border.all(color: Colors.white, width: 4),
                                    color: Color(0x55000000)
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                            child: Text("Best room name",
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(color: Colors.white, thickness: 4, height: 0,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                            child: Text("PIN: 123456",
                                              style: whiteText,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(color: Colors.white, thickness: 4, height: 0,),
                                      PlayerGrid(),
                                    ],
                                  )
                                ),
                              )
                          ),
                          Spacer(),
                          PillButton("Leave", redirect: "/home",),
                          Spacer(),
                        ],
                      ),
                    ),
                  ],
                )
            ),
          )
        ],
      ),
    );
  }
}