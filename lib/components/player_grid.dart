import 'package:amikoj/constants/constants.dart';
import 'package:amikoj/models/user_module.dart';
import 'package:amikoj/redux/app_state.dart';
import 'package:amikoj/redux/room_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayerGrid extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RoomState>(
        rebuildOnChange: true,
        converter: (store) => store.state.roomState,
        builder: (context, state) {
          return Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(36), bottomRight: Radius.circular(36)),
              child: GridView.count(
                  childAspectRatio: 6,
                  crossAxisCount: 1,
                  padding: const EdgeInsets.all(4.0),
                  children: getCards(state)
              ),
            ),
          );
        }
    );
  }

  Widget playerCard(UserModule player, bool isHost) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(360),
            border: Border.all(color: Colors.white, width: 1),
        ),
        height: double.infinity,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                width: 44.0,
                height: double.infinity,
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: new NetworkImage(player.avatarUrl),
                    )
                )),
            Text(player.name, style: whiteText),
            isHost ?
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: FaIcon(
                FontAwesomeIcons
                    .times,
                color: Colors.white,
                size: 20,
              ),
            ) :
                Container(width: 38,)
          ],
        ),
      ),
    );
  }

  List<Widget> getCards(RoomState roomState) {
    List<Widget> widgets = roomState.players.map(
            (e) => playerCard(e, isHostPlayer(roomState, e))).toList();
    return widgets;
  }

  bool isHostPlayer(RoomState roomState, UserModule player) {
    print('AAAA ${roomState.hostId} ${player.uid}');
    return roomState.hostId == player.uid;
  }
}
