import 'package:flutter/material.dart';

class PlayerGrid extends StatelessWidget {

  Widget playerCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.red,
        child: Text("AAA"),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(36), bottomRight: Radius.circular(36)),
        child: GridView.count(
          crossAxisCount: 2,
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
