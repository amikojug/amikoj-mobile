import 'dart:math';

import 'package:amikoj/models/user_module.dart';
import 'package:amikoj/redux/app_state.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart';
// import 'package:flutter/widgets.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'dart:math' show Rectangle;

import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meta/meta.dart' show required;

class HorizontalBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  HorizontalBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory HorizontalBarChart.withSampleData(BuildContext context) {
    return new HorizontalBarChart(
      _createSampleData(context),
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      vertical: true,
      // barRendererDecorator: new BarLabelDecorator(),
      primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: new charts.GridlineRendererSpec(
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 18, // size in Pts.
                  color: charts.MaterialPalette.white),
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.white))),
      domainAxis: new charts.OrdinalAxisSpec(
        renderSpec: new charts.SmallTickRendererSpec(
          labelStyle: new charts.TextStyleSpec(
            fontSize: 18, // size in Pts.
            color: charts.MaterialPalette.white),
          lineStyle: new charts.LineStyleSpec(
              color: charts.MaterialPalette.white),
        ),
      ),
    );
  }


  /// Create one series with sample hard coded data.
  static List<charts.Series<PlayerScoreData, String>> _createSampleData(BuildContext ctx) {
    List<UserModule> players = StoreProvider.of<AppState>(ctx).state.roomState.players;
    List<PlayerScoreData> data = new List();
    players.forEach((player) {
      data.add(new PlayerScoreData(player.name, player.score));
    });

    return [
      new charts.Series<PlayerScoreData, String>(
        id: 'Sales',
        domainFn: (PlayerScoreData sales, _) => sales.playerName,
        measureFn: (PlayerScoreData sales, _) => sales.score,
        data: data,
        colorFn: (PlayerScoreData sales, _) =>
          charts.MaterialPalette.deepOrange.shadeDefault,
      )
    ];
  }
}

// TODO finish rendering avatars near player's bar
// class BarLabelDecorator extends charts.BarLabelDecorator<dynamic> {
//   @override
//   void decorate(Object barElements,
//       ChartCanvas canvas, GraphicsFactory graphicsFactory,
//       {@required Rectangle drawBounds,
//         @required double animationPercent,
//         @required bool renderingVertically,
//         bool rtl = false}) {
//     super.decorate(barElements, canvas, graphicsFactory, drawBounds: null, animationPercent: null, renderingVertically: null);
//     canvas.drawRect(Rectangle(0, 0, 10, 10), fill: Color.black, );
//   }
// }


/// Sample ordinal data type.
class PlayerScoreData {
  final String playerName;
  final int score;

  PlayerScoreData(this.playerName, this.score);
}