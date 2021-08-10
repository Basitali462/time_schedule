import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_scheduler/constants/constant_colors.dart';

class ClockPainter extends CustomPainter{

  var dateTime = DateTime.now();

  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);
    var blurPath = Path();
    var blurPathOuter = Path();
    var secPath = Path();
    var innerCircle = Paint()..color = kGreyColor;
    var outerCircle = Paint()..color = kGreyColor;
    var dialCircle = Paint()..color = kClockRing;
    var centerCircle = Paint()..color = kRedColor;

    var secBrush = Paint()
      ..color = kRedColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    var minBrush = Paint()
      ..color = kPurpleColor
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
      ..color = kShadowColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    blurPath.addOval(Rect.fromCircle(center: center, radius: radius - (radius/1.4)));

    //calculating sec coordinates
    //60sec - 360, 1sec = 6 degrees
    var secHandX = centerX + (centerX * 0.85) * cos(dateTime.second * 6 * pi / 180);
    var secHandY = centerX + (centerX * 0.85) * sin(dateTime.second * 6 * pi / 180);

    //calculating min coordinates
    var minHandX = centerX + (centerX * 0.65) * cos(dateTime.minute * 6 * pi / 180);
    var minHandY = centerX + (centerX * 0.65) * sin(dateTime.minute * 6 * pi / 180);

    //calculating hour coordinates
    //12hours - 360, 1hour - 30degree, 1min - 0.5degree
    var hourHandX = centerX + (centerX * 0.4) * cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    var hourHandY = centerX + (centerX * 0.4) * sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);

    //secPath.moveTo(secHandX, secHandY);
    //secPath.lineTo(secPointX, secPointY);
    //secPath.addOval(Rect.fromPoints(Offset(centerX,centerY + 4), Offset(secHandX, secHandY)));
    canvas.drawCircle(center, radius, dialCircle);
    blurPathOuter.addOval(Rect.fromCircle(center: center, radius: radius - (radius/4.5)));
    canvas.drawShadow(blurPathOuter, Colors.grey.withOpacity(0.1), 3, true);
    canvas.drawCircle(center, radius - (radius/4.5), outerCircle);
    canvas.drawShadow(blurPath.shift(Offset(1,1)), Colors.grey.withOpacity(0.1), 3, true);
    canvas.drawCircle(center, radius - (radius/1.4), innerCircle);
    canvas.drawLine(center, Offset(minHandX, minHandY), minBrush);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourBrush);
    canvas.drawLine(center, Offset(secHandX, secHandY), secBrush);
    //canvas.drawPath(secPath, secBrush);
    canvas.drawCircle(center, radius - (radius/1.05), centerCircle);

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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}

//Offset(centerX + 15, centerY + 13)