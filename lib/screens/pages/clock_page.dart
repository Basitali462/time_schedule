import 'dart:async';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_scheduler/config/size_config.dart';
import 'package:time_scheduler/constants/bit_clock.dart';
import 'package:time_scheduler/constants/page_indicator.dart';
import 'package:time_scheduler/custom_paints/clock_painter.dart';
import 'package:time_scheduler/constants/app_theme.dart';

class Clock extends StatefulWidget {
  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {

  int activeIndex = 0;

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

  Widget analogClock(){
    return Column(
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
    );
  }

  /*Widget bitClock(){
    return Container(
      color: Colors.black,
      width: 50,
      height: 50,
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: CarouselSlider(
              options: CarouselOptions(
                  height: double.infinity,
                  aspectRatio: 1,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      activeIndex = index;
                    });
                  }
              ),
              items: [analogClock(), BitClock()].map((e) {
                return Builder(builder: (BuildContext context){
                  return e;
                });
              }).toList(),
            ),
          ),
          PageIndicator(activeIndex: activeIndex,),
          SizedBox(height: 50,)
        ],
      ),
    );
  }
}
