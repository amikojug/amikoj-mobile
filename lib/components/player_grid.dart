import 'package:amikoj/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayerGrid extends StatelessWidget {

  Widget playerCard() {
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
                        image: new NetworkImage(
                            "https://i.imgur.com/BoN9kdC.png")
                    )
                )),
            Text("AAA", style: whiteText),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: FaIcon(
                FontAwesomeIcons
                    .times,
                color: Colors.white,
                size: 20,
              ),
            )
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(36), bottomRight: Radius.circular(36)),
        child: GridView.count(
          childAspectRatio: 6,
          crossAxisCount: 1,
          padding: const EdgeInsets.all(4.0),
          children: List.generate(100, (index) {
            return Center(
              child: playerCard()
            );
          }),
        ),
      ),
    );
  }
}
