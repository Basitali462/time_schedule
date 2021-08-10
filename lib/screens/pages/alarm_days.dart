import 'package:flutter/material.dart';
import 'package:time_scheduler/config/size_config.dart';
import 'package:time_scheduler/constants/constant_colors.dart';
import 'package:time_scheduler/constants/static_var.dart';

class AlarmDays extends StatefulWidget {
  @override
  _AlarmDaysState createState() => _AlarmDaysState();

  final Function pageChange;

  AlarmDays({this.pageChange});

}

class _AlarmDaysState extends State<AlarmDays> {

  Widget daysName(String name, bool check){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: kDimOutline,
        border: Border.symmetric(
          horizontal: BorderSide(
            color: kShadowColor,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 2 * SizeConfig.textMultiplier,
            ),
          ),
          check ? Icon(
            Icons.check,
            color: kYellowColor,
          ) : Container(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          leadingWidth: 100,
          automaticallyImplyLeading: false,
          backgroundColor: kPurpleColor,
          leading: InkWell(
            onTap: (){
              widget.pageChange(0);
            },
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  color: kYellowColor,
                ),
                Text(
                  'Back',
                  style: TextStyle(
                    fontSize: 2.39 * SizeConfig.textMultiplier,
                    color: kYellowColor,
                  ),
                ),
              ],
            ),
          ),
          title: Text(
            'Repeat'
          ),
        ),
        body: ListView(
          padding: EdgeInsets.only(top: 40),
          children: [
            InkWell(
              onTap: (){
                checkSun = !checkSun;
                setState(() {

                });
              },
              child: daysName('Every Sunday', checkSun),
            ),
            InkWell(
              onTap: (){
                checkMon = !checkMon;
                setState(() {

                });
              },
              child: daysName('Every Monday', checkMon),
            ),
            InkWell(
              onTap: (){
                checkTue = !checkTue;
                setState(() {

                });
              },
              child: daysName('Every Tuesday', checkTue),
            ),
            InkWell(
              onTap: (){
                checkWed = !checkWed;
                setState(() {

                });
              },
              child: daysName('Every Wednesday', checkWed),
            ),
            InkWell(
              onTap: (){
                checkThu = !checkThu;
                setState(() {

                });
              },
              child: daysName('Every Thursday', checkThu),
            ),
            InkWell(
              onTap: (){
                checkFri = !checkFri;
                setState(() {

                });
              },
              child: daysName('Every Friday', checkFri),
            ),
            InkWell(
              onTap: (){
                checkSat = !checkSat;
                setState(() {

                });
              },
              child: daysName('Every Saturday', checkSat),
            ),
          ],
        ),
      ),
    );
  }
}
