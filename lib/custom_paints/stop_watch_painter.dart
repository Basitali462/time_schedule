import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_scheduler/constants/constant_colors.dart';

class StopWatchPainter extends CustomPainter{

  var dateTime = DateTime.now();

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);
    var dialCircle = Paint()..color = kClockRing;
    var centerCircle = Paint()..color = kRedColor;

    var secBrush = Paint()
      ..color = kRedColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    var hourBrush = Paint()
      ..color = kYellowColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    var dashesBrush = Paint()
      ..color = kWhiteColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    var boldDashBrush = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    //calculating sec coordinates
    //60sec - 360, 1sec = 6 degrees
    var secHandX = centerX + (centerX * 1) * cos((dateTime.millisecond * 0.01) * pi / 180);
    var secHandY = centerX + (centerX * 1) * sin((dateTime.millisecond * 0.01) * pi / 180);

    //calculating hour coordinates
    //12hours - 360, 1hour - 30degree, 1min - 0.5degree
    var hourHandX = centerX + (centerX * 1) * cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    var hourHandY = centerX + (centerX * 1) * sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);

    canvas.drawCircle(center, radius, dialCircle);
    var outerCircleRadius = radius - 10;
    var innerCircleRadius = radius - 20;
    for(double i = 0; i < 360; i+=6){
      var x1 = centerX + outerCircleRadius * cos(i * pi / 180);
      var y1 = centerX + outerCircleRadius * sin(i * pi / 180);

      var x2 = centerX + innerCircleRadius * cos(i * pi / 180);
      var y2 = centerX + innerCircleRadius * sin(i * pi / 180);

      if(i == 0 || i == 30 || i == 60 ||
          i == 90 || i == 120 || i == 150
          || i == 180 || i == 210 || i == 240
          || i == 270 || i == 300 || i == 330){
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), boldDashBrush);
      }else{
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashesBrush);
      }
    }
    //canvas.drawLine(center, Offset(hourHandX, hourHandY), hourBrush);
    canvas.drawLine(center, Offset(secHandX, secHandY), secBrush);
    canvas.drawCircle(center, radius - (radius/1.05), centerCircle);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}