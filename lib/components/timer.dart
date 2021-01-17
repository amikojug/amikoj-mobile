import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class CountDownTimer extends StatefulWidget {
  final int size;
  final Function onFinish;
  final TimerController timerController;

  CountDownTimer({this.size, this.onFinish, this.timerController});

  @override
  _CountDownTimerState createState() => _CountDownTimerState(size, onFinish, timerController);
}

class _CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {

  AnimationController controller;

  final int size;

  final Function onFinish;

  final TimerController timerController;

  _CountDownTimerState(this.size, this.onFinish, this.timerController) {
    this.timerController.setCountDownState(this);
  }


  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 8),
    );
    controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        onFinish();
      }
    });
    controller.reverse(
        from: controller.value == 0.0
            ? 1.0
            : controller.value);

  }

  void reset() {
    controller.reverse(from: 1.0);
  }

  void stop() {
    controller.stop();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white10,
      body:
      AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.center,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: Stack(
                                children: <Widget>[
                                  Positioned.fill(
                                    child: CustomPaint(
                                        painter: InnerPainter(
                                            animation: controller,
                                            size: this.size
                                        )),
                                  ),
                                  Positioned.fill(
                                    child: CustomPaint(
                                        painter: CustomTimerPainter(
                                          animation: controller,
                                          backgroundColor: Colors.white,
                                          color: themeData.indicatorColor,
                                          size: this.size
                                        )),
                                  ),
                                  Align(
                                    alignment: FractionalOffset.center,
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          timerString,
                                          style: TextStyle(
                                              fontSize: size.toDouble() * 0.3,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class TimerController {
   _CountDownTimerState state;

  void setCountDownState(_CountDownTimerState state) {
    this.state = state;
  }

  void resetTimer() {
    state.reset();
  }

  void stopTimer() {
    state.stop();
  }
}


class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
    this.size,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;
  final int size;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), this.size / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Rect.fromCircle(center: size.center(Offset.zero), radius: this.size / 2.0), math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}

class InnerPainter extends CustomPainter {
  InnerPainter({
    this.animation,
    this.size,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final int size;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 20.0
      ..style = PaintingStyle.fill;

    paint.color = Color(0x77000000);
    canvas.drawCircle(size.center(Offset.zero), this.size / 2.0, paint);
  }

  @override
  bool shouldRepaint(InnerPainter old) {
    return animation.value != old.animation.value;
  }
}