import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:time_scheduler/constants/constant_colors.dart';

class BedTimePainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);
    var innerCircle = Paint()..color = kPurpleColor;
    var outerCircle = Paint()..color = kGreyColor;
    var dialCircle = Paint()..color = kClockRing;

    canvas.drawCircle(center, radius, dialCircle);
    canvas.drawCircle(center, radius - (radius/6), outerCircle);
    canvas.drawCircle(center, radius - (radius/2), innerCircle);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}