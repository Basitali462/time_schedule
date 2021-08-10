import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_scheduler/config/size_config.dart';
import 'package:time_scheduler/custom_paints/clock_painter.dart';
import 'package:time_scheduler/constants/app_theme.dart';

class Clock extends StatefulWidget {
  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {

  @override
  void initState() {
    // TODO: implement initState
    Timer.periodic(Duration(seconds: 1), (timer) {
      if(mounted){
        setState(() {

        });
      }
    });
    super.initState();
  }

  String getDateTime(){
    DateTime now = DateTime.now();
    return DateFormat('hh:mm a').format(now);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 2.3 * SizeConfig.heightMultiplier,
              horizontal: 8.5 * SizeConfig.widthMultiplier,
            ),
            child: Text(
              getDateTime(),
              maxLines: 1,
              style: Theme.of(context).textTheme.clockText,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8 * SizeConfig.widthMultiplier),
              child: Align(
                alignment: Alignment.center,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Transform.rotate(
                    angle: -pi / 2,
                    child: CustomPaint(
                      painter: ClockPainter(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 9 * SizeConfig.heightMultiplier,),
        ],
      ),
    );
  }
}
