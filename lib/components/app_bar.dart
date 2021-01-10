import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:amikoj/constants/constants.dart';
import 'dart:ui';

import 'package:amikoj/redux/app_state.dart';
import 'package:amikoj/redux/user_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:amikoj/services/auth.dart';

PreferredSizeWidget AmikojAppBar(BuildContext context) {
  final AuthService _auth = AuthService();

  return AppBar(
    backgroundColor: Color(0xFFBB81F6),
    leading: FlatButton(
      onPressed: () async {
        await _auth.signOut(context);
        Navigator.popUntil(context, (route) => route.isFirst);
      },
      child: Icon(Icons.logout, color: Colors.white),
    ),
    actions: [
      StoreConnector<AppState, UserState>(
          rebuildOnChange: true,
          converter: (store) => store.state.userState,
          builder: (context, state) {
            return FlatButton(
              color: Colors.transparent,
              onPressed: () {
                Navigator.pushNamed(context, '/account');
              },
              child: Row(
                children: [
                  Text(
                    state.name,
                    style: whiteText,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        key: Key(state.avatarUrl),
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        imageUrl: state.avatarUrl,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          })
    ],
  );
  // }
}
