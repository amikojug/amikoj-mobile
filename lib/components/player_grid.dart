import 'package:amikoj/constants/constants.dart';
import 'package:amikoj/models/user_module.dart';
import 'package:amikoj/redux/app_state.dart';
import 'package:amikoj/redux/room_reducer.dart';
import 'package:amikoj/redux/room_state.dart';
import 'package:amikoj/services/realtime_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36)),
              child: GridView.count(
                  childAspectRatio: MediaQuery.of(context).size.width / 66,
                  crossAxisCount: 1,
                  padding: const EdgeInsets.all(4.0),
                  children: getCards(state, context)),
            ),
          );
        });
  }

  Widget playerCard(UserModule player, bool isHost, BuildContext context) {
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
            ClipOval(
              child: CachedNetworkImage(
                key: Key(player.avatarUrl),
                width: 44,
                height: 44,
                fit: BoxFit.cover,
                imageUrl: player.avatarUrl,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    CircularProgressIndicator(),
              ),
            ),
            Text(player.name, style: whiteText),
            false //TODO !isHost fix baning players
                ? IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.times,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () async {
                      removePlayerFromRoom(player.uid);
                      StoreProvider.of<AppState>(context).dispatch(ResetRoom());
                    },
                  )
                : Container(
                    width: 38,
                  )
          ],
        ),
      ),
    );
  }

  List<Widget> getCards(RoomState roomState, BuildContext context) {
    List<Widget> widgets = roomState.players
        .map((e) => playerCard(e, isHostPlayer(roomState, e), context))
        .toList();
    return widgets;
  }

  bool isHostPlayer(RoomState roomState, UserModule player) {
    print('AAAA ${roomState.hostId} ${player.uid}');
    return roomState.hostId == player.uid;
  }
}
