import 'package:flutter/material.dart';

import 'package:amikoj/pages/access_page.dart';
import 'package:amikoj/pages/login_page.dart';
import 'package:amikoj/pages/register_page.dart';
import 'package:amikoj/pages/home_page.dart';
import 'package:amikoj/pages/create_room_page.dart';
import 'package:amikoj/pages/join_room_page.dart';
import 'package:amikoj/pages/account_page.dart';
import 'package:amikoj/pages/room.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Amikoj',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => AccessPage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
        '/createRoom': (context) => CreateRoomPage(),
        '/joinRoom': (context) => JoinRoomPage(),
        '/room': (context) => RoomPage(),
        '/account': (context) => AccountPage(),
      },
    );
  }
}