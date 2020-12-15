import 'package:amikoj/pages/round_page.dart';
import 'package:amikoj/redux/app_reducer.dart';
import 'package:amikoj/redux/app_state.dart';
import 'package:flutter/material.dart';

import 'package:amikoj/pages/access_page.dart';
import 'package:amikoj/pages/login_page.dart';
import 'package:amikoj/pages/register_page.dart';
import 'package:amikoj/pages/home_page.dart';
import 'package:amikoj/pages/create_room_page.dart';
import 'package:amikoj/pages/join_room_page.dart';
import 'package:amikoj/pages/account_page.dart';
import 'package:amikoj/pages/room_page.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

final Store<AppState> store = Store<AppState>(appReducer,
    initialState: AppState.initialState());

Store<AppState> getStore() {
  return store;
}

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new StoreProvider<AppState>(
      store: store,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: MaterialApp(
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
            '/round': (context) => RoundPage(),
          },
        ),
      ),
    );
  }
}