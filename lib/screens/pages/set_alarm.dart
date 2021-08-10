import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_scheduler/config/size_config.dart';
import 'package:time_scheduler/constants/constant_colors.dart';
import 'package:time_scheduler/constants/inner_shadow.dart';
import 'package:time_scheduler/constants/processing_indicator.dart';
import 'package:time_scheduler/constants/static_var.dart';
import 'package:time_scheduler/constants/time_picker_spinner.dart';
import 'package:time_scheduler/models/alarm_model.dart';
import 'package:time_scheduler/models/crud_model.dart';
import 'package:time_scheduler/services/notification_plugin.dart';
import 'package:time_scheduler/screens/pages/alarm_days.dart';
import 'package:time_scheduler/services/database.dart';

class SetAlarm extends StatefulWidget {
  @override
  _SetAlarmState createState() => _SetAlarmState();

  final Function pageChange;

  SetAlarm({this.pageChange});
}

class _SetAlarmState extends State<SetAlarm> {

  DateTime _dateTime;

  bool toggleVal = false;
  bool settingAlarm = false;
  List<String> repeatDays = [];

  void switchToggle(){
    setState(() {
      toggleVal = !toggleVal;
    });
  }

  Widget setAlarmTime(){
    return TimePickerSpinner(
      itemHeight: 4.49 * SizeConfig.heightMultiplier,
      itemWidth: 10 * SizeConfig.widthMultiplier,
      highlightedTextStyle: TextStyle(
        fontSize: 2.9 * SizeConfig.textMultiplier,
        color: kYellowColor,
      ),
      normalTextStyle: TextStyle(
        fontSize: 2 * SizeConfig.textMultiplier,
        color: Colors.transparent,
      ),
      is24HourMode: false,
      isForce2Digits: true,
      spacing: 8,
      onTimeChange: (time){
        if(mounted){
          setState(() {
            _dateTime = time;
          });
        }
      },
    );
    return CupertinoDatePicker(
      backgroundColor: Colors.transparent,
      initialDateTime: _dateTime,
      mode: CupertinoDatePickerMode.time,
      onDateTimeChanged: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }

  void checkAlarmDays(){
    if(checkSun){
      repeatDays.add('Sun');
    }
    if(checkMon){
      repeatDays.add('Mon');
    }
    if(checkTue){
      repeatDays.add('Tue');
    }
    if(checkWed){
      repeatDays.add('Wed');
    }
    if(checkThu){
      repeatDays.add('Thu');
    }
    if(checkFri){
      repeatDays.add('Fri');
    }
    if(checkSat){
      repeatDays.add('Sat');
    }
    if(checkSun == false && checkMon == false
        && checkTue == false && checkWed == false && checkThu == false
        && checkFri == false && checkSat == false){
      repeatDays.clear();
      repeatDays.add('Never');
    }
    if(checkSun == true && checkMon == true
        && checkTue == true && checkWed == true && checkThu == true
        && checkFri == true && checkSat == true){
      repeatDays.clear();
      repeatDays.add('EveryDay');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAlarmDays();
  }

  @override
  Widget build(BuildContext context) {
    final alarmProvider = Provider.of<CRUDModel>(context);
    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: kPurpleColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 2 * SizeConfig.textMultiplier,
                        color: kYellowColor,
                      ),
                    ),
                  ),
                  Text(
                    'Add Alarm',
                    style: TextStyle(
                      fontSize: 2.69 * SizeConfig.textMultiplier,
                      color: kWhiteColor,
                    ),
                  ),
                  InkWell(
                    onTap: () async{
                      setState(() {
                        settingAlarm = true;
                      });
                      await alarmProvider.addAlarm(ModelAlarm(
                        alarmTime: Timestamp.fromMillisecondsSinceEpoch(_dateTime.millisecondsSinceEpoch),
                        repeatDays: repeatDays,
                        isActive: toggleVal,
                      )).then((value) {
                        setState(() {
                          settingAlarm = false;
                        });
                        Navigator.pop(context);
                      });
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 2 * SizeConfig.textMultiplier,
                        color: kYellowColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Time',
                        style: TextStyle(
                          fontSize: 2.69 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Spacer(),
                      Stack(
                        clipBehavior: Clip.hardEdge,
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                width: 2,
                                color: kYellowColor
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            height: 7.4 * SizeConfig.heightMultiplier,
                            width: 40 * SizeConfig.widthMultiplier,
                          ),
                          setAlarmTime(),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: kDimOutline,
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: kShadowColor,
                      ),
                    ),
                  ),
                  child: InkWell(
                    onTap: (){
                      widget.pageChange(1);
                    },
                    child: ListTile(
                      leading: Text(
                        'Repeat',
                        style: TextStyle(
                          fontSize: 2 * SizeConfig.textMultiplier,
                        ),
                      ),
                      trailing: Text(
                        repeatDays.join(', '),
                        style: TextStyle(
                          fontSize: 2 * SizeConfig.textMultiplier,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: SizeConfig.heightMultiplier),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: kDimOutline,
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: kShadowColor,
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: Text(
                      'Active',
                      style: TextStyle(
                        fontSize: 2 * SizeConfig.textMultiplier,
                      ),
                    ),
                    trailing: InnerShadow(
                      blur: 2,
                      color: kInnerShadow,
                      offset: Offset(1, 1),
                      child: Container(
                        width: 18 * SizeConfig.widthMultiplier,
                        height: 5.5 * SizeConfig.heightMultiplier,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6 * SizeConfig.heightMultiplier),
                          color: kGreyColor,
                          border: Border.all(width: 3, color: kDimOutline),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AnimatedPositioned(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                                left: toggleVal ? 8 * SizeConfig.widthMultiplier : 0,
                                child: InkWell(
                                  onTap: switchToggle,
                                  child: Container(
                                    width: 6.3 * SizeConfig.widthMultiplier,
                                    height: 3.7 * SizeConfig.heightMultiplier,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: toggleVal ? kYellowColor : kPurpleColor,
                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          toggleVal ? 'ON' : 'OFF',
                                          style: TextStyle(
                                            color: toggleVal ? kPurpleColor : kGreyColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: settingAlarm ? ProcessingIndicator() : null,
          ),
        ],
      ),
    );
  }
}
