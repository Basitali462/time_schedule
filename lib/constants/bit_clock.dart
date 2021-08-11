import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:time_scheduler/constants/binary_time.dart';
import 'package:time_scheduler/constants/clock_column.dart';
import 'package:time_scheduler/constants/app_theme.dart';

import '../config/size_config.dart';
import 'constant_colors.dart';
import 'constant_colors.dart';
import 'constant_colors.dart';
import 'constant_colors.dart';

class BitClock extends StatefulWidget {
  @override
  _BitClockState createState() => _BitClockState();
}

class _BitClockState extends State<BitClock> {
  //DateTime now = DateTime.now();
  BinaryTime now = BinaryTime();

  @override
  void initState() {
    // TODO: implement initState
    Timer.periodic(Duration(seconds: 1), (timer) {
      if(mounted){
        setState(() {
          now = BinaryTime();
        });
      }
    });
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClockColumn(
            binaryInt: now.hourTens,
            title: 'H',
            color: kPurpleColor.withOpacity(0.9),
            rows: 2,
          ),
          ClockColumn(
            binaryInt: now.hourOnes,
            title: 'h',
            color: kPurpleColor.withOpacity(0.7),
          ),
          ClockColumn(
            binaryInt: now.minuteTens,
            title: 'M',
            color: kYellowColor.withOpacity(0.9),
            rows: 3,
          ),
          ClockColumn(
            binaryInt: now.minuteOnes,
            title: 'm',
            color: kYellowColor.withOpacity(0.7),
          ),
          ClockColumn(
            binaryInt: now.secondsTens,
            title: 'S',
            color: kRedColor.withOpacity(0.9),
            rows: 3,
          ),
          ClockColumn(
            binaryInt: now.secondsOnes,
            title: 's',
            color: kRedColor.withOpacity(0.7),
          ),
        ],
      ),
    );
  }
}
