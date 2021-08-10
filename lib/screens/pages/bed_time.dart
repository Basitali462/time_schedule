import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_scheduler/config/size_config.dart';
import 'package:time_scheduler/config/size_configuration.dart';
import 'package:time_scheduler/constants/constant_colors.dart';
import 'package:time_scheduler/constants/inner_shadow.dart';
import 'package:time_scheduler/constants/static_var.dart';
import 'package:time_scheduler/custom_paints/bed_time_paint.dart';
import 'package:time_scheduler/constants/app_theme.dart';
import 'package:time_scheduler/models/bed_time_model.dart';
import 'package:time_scheduler/models/crud_model.dart';
import 'package:time_scheduler/services/notification_plugin.dart';
import 'package:time_scheduler/shared/shared_prefs.dart';


class BedTime extends StatefulWidget {
  @override
  _BedTimeState createState() => _BedTimeState();
}

class _BedTimeState extends State<BedTime> {

  bool toggleVal = false;
  //List<String> bedTimeDay = [];
  List<BedTimeModel> bedTimeSch;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future switchToggle(BuildContext context) async{
    if(bedTimeSch[0].repeatDays.length <= 0){
      Fluttertoast.showToast(
        msg: 'Please Select Day to Schedule BedTime',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }else{
      setState((){
        toggleVal = !bedTimeSch[0].isActive;
      });
      await updateBedTime(
        context,
        BedTimeModel(
          bedTime: bedTimeSch[0].bedTime,
          wakeUpTime: bedTimeSch[0].wakeUpTime,
          inBed: bedTimeSch[0].inBed,
          outBed: bedTimeSch[0].outBed,
          isActive: toggleVal,
          repeatDays: bedTimeSch[0].repeatDays,
        )
      );
    }
  }

  Future updateBedTime(BuildContext context, BedTimeModel data) async{
    print('updating bed time');
    final bedTimeProvider = Provider.of<CRUDModel>(context, listen: false);
    await bedTimeProvider.updateBedTimeSchedule(data, bedTimeSch[0].id);
    return ;
  }

  Widget scheduleSwitch(BuildContext context){
    return Padding(
      padding: EdgeInsets.only(right: 8.5 * SizeConfig.widthMultiplier),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'BedTime Schedule',
            style: Theme.of(context).textTheme.bodyText,
          ),
          InnerShadow(
            blur: 2,
            color: kInnerShadow,
            offset: Offset(1, 1),
            child: Container(
              width: 21 * SizeConfig.widthMultiplier,
              height: 6.5 * SizeConfig.heightMultiplier,
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
                      left: bedTimeSch[0].isActive ? 8 * SizeConfig.widthMultiplier : 0,
                      child: InkWell(
                        onTap: () async{
                          print('toggle tapped');
                          await switchToggle(context);
                        },
                        child: Container(
                          width: 9.3 * SizeConfig.widthMultiplier,
                          height: 5.5 * SizeConfig.heightMultiplier,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: bedTimeSch[0].isActive ? kYellowColor : kPurpleColor,
                          ),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                bedTimeSch[0].isActive ? 'ON' : 'OFF',
                                style: TextStyle(
                                  color: bedTimeSch[0].isActive ? kPurpleColor : kGreyColor,
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
        ],
      ),
    );
  }

  Widget weekButton(String text, bool active){
    return Container(
      //margin: EdgeInsets.only(right: 20),
      alignment: Alignment.center,
      width: 13.33 * SizeConfig.widthMultiplier,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: active ? Colors.transparent : kWhiteColor,
        ),
        borderRadius: BorderRadius.circular(1.7 * SizeConfig.heightMultiplier),
        gradient: LinearGradient(
          colors: [
            active ? kYellowColor : kGreyColor,
            kInnerShadow,
          ],
          begin: Alignment(0, 0),
          end: Alignment(4, 4)
        )
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyText,
      ),
    );
  }

  Widget weekDays(int i, BuildContext context){
    switch(i){
      case 0:
        return InkWell(
          onTap: () async{
            bedTimeSun = !bedTimeSun;
            setState(() {
              /*bedTimeSch[0].repeatDays.contains('Sun')
                  ? bedTimeSch[0].repeatDays.removeWhere((element) => element == 'Sun')
                  : bedTimeSch[0].repeatDays.add('Sun');*/
              if(bedTimeSch[0].repeatDays.contains('Sun')){
                bedTimeSch[0].repeatDays.removeWhere((element) => element == 'Sun');
                notificationPlugin.cancelSingleNotification(bedTimeSch[0].id.hashCode);
              }else if(!bedTimeSun){
                bedTimeSch[0].repeatDays.add('Sun');
              }
              //bedTimeSch[0].repeatDays = bedTimeDay;
            });
            await updateBedTime(
              context,
              BedTimeModel(
                bedTime: bedTimeSch[0].bedTime,
                wakeUpTime: bedTimeSch[0].wakeUpTime,
                inBed: bedTimeSch[0].inBed,
                outBed: bedTimeSch[0].outBed,
                isActive: bedTimeSch[0].isActive,
                repeatDays: bedTimeSch[0].repeatDays,
              ),
            );
          },
          child: bedTimeSch[0].repeatDays.contains('Sun')
              ? weekButton('S', true)
              : weekButton('S', false),
        );
        break;
      case 1:
        return InkWell(
          onTap: () async{
            bedTimeMon = !bedTimeMon;
            setState(() {
              /*bedTimeSch[0].repeatDays.contains('Mon')
                  ? bedTimeSch[0].repeatDays.removeWhere((element) => element == 'Mon')
                  : bedTimeSch[0].repeatDays.add('Mon');*/
              if(bedTimeSch[0].repeatDays.contains('Mon')){
                bedTimeSch[0].repeatDays.removeWhere((element) => element == 'Mon');
                notificationPlugin.cancelSingleNotification(bedTimeSch[0].id.hashCode);
              }else if(!bedTimeMon){
                bedTimeSch[0].repeatDays.add('Mon');
              }
              //bedTimeSch[0].repeatDays = bedTimeDay;
            });
            await updateBedTime(
              context,
              BedTimeModel(
                bedTime: bedTimeSch[0].bedTime,
                wakeUpTime: bedTimeSch[0].wakeUpTime,
                inBed: bedTimeSch[0].inBed,
                outBed: bedTimeSch[0].outBed,
                isActive: bedTimeSch[0].isActive,
                repeatDays: bedTimeSch[0].repeatDays,
              ),
            );
          },
          child: bedTimeSch[0].repeatDays.contains('Mon')
              ? weekButton('M', true)
              : weekButton('M', false),
        );
        break;
      case 2:
        return InkWell(
          onTap: () async{
            bedTimeTue = !bedTimeTue;
            setState(() {
              /*bedTimeSch[0].repeatDays.contains('Tue')
                  ? bedTimeSch[0].repeatDays.removeWhere((element) => element == 'Tue')
                  : bedTimeSch[0].repeatDays.add('Tue');*/
              if(bedTimeSch[0].repeatDays.contains('Tue')){
                bedTimeSch[0].repeatDays.removeWhere((element) => element == 'Tue');
                notificationPlugin.cancelSingleNotification(bedTimeSch[0].id.hashCode);
              }else if(!bedTimeTue){
                bedTimeSch[0].repeatDays.add('Tue');
              }
              //bedTimeSch[0].repeatDays = bedTimeDay;
            });
            await updateBedTime(
              context,
              BedTimeModel(
                bedTime: bedTimeSch[0].bedTime,
                wakeUpTime: bedTimeSch[0].wakeUpTime,
                inBed: bedTimeSch[0].inBed,
                outBed: bedTimeSch[0].outBed,
                isActive: bedTimeSch[0].isActive,
                repeatDays: bedTimeSch[0].repeatDays,
              ),
            );
          },
          child: bedTimeSch[0].repeatDays.contains('Tue')
              ? weekButton('T', true)
              : weekButton('T', false),
        );
        break;
      case 3:
        return InkWell(
          onTap: () async{
            bedTimeWed = !bedTimeWed;
            setState(() {
              /*bedTimeSch[0].repeatDays.contains('Wed')
                  ? bedTimeSch[0].repeatDays.removeWhere((element) => element == 'Wed')
                  : bedTimeSch[0].repeatDays.add('Wed');*/
              if(bedTimeSch[0].repeatDays.contains('Wed')){
                bedTimeSch[0].repeatDays.removeWhere((element) => element == 'Wed');
                notificationPlugin.cancelSingleNotification(bedTimeSch[0].id.hashCode);
              }else if(!bedTimeWed){
                bedTimeSch[0].repeatDays.add('Wed');
              }
              //bedTimeSch[0].repeatDays = bedTimeDay;
            });
            await updateBedTime(
              context,
              BedTimeModel(
                bedTime: bedTimeSch[0].bedTime,
                wakeUpTime: bedTimeSch[0].wakeUpTime,
                inBed: bedTimeSch[0].inBed,
                outBed: bedTimeSch[0].outBed,
                isActive: bedTimeSch[0].isActive,
                repeatDays: bedTimeSch[0].repeatDays,
              ),
            );
          },
          child: bedTimeSch[0].repeatDays.contains('Wed')
              ? weekButton('W', true)
              : weekButton('W', false),
        );
        break;
      case 4:
        return InkWell(
          onTap: () async{
            bedTimeThu = !bedTimeThu;
            setState(() {
              /*bedTimeSch[0].repeatDays.contains('Thu')
                  ? bedTimeSch[0].repeatDays.removeWhere((element) => element == 'Thu')
                  : bedTimeSch[0].repeatDays.add('Thu');*/
              if(bedTimeSch[0].repeatDays.contains('Thu')){
                bedTimeSch[0].repeatDays.removeWhere((element) => element == 'Thu');
                notificationPlugin.cancelSingleNotification(bedTimeSch[0].id.hashCode);
              }else if(!bedTimeThu){
                bedTimeSch[0].repeatDays.add('Thu');
              }
              //bedTimeSch[0].repeatDays = bedTimeDay;
            });
            await updateBedTime(
              context,
              BedTimeModel(
                bedTime: bedTimeSch[0].bedTime,
                wakeUpTime: bedTimeSch[0].wakeUpTime,
                inBed: bedTimeSch[0].inBed,
                outBed: bedTimeSch[0].outBed,
                isActive: bedTimeSch[0].isActive,
                repeatDays: bedTimeSch[0].repeatDays,
              ),
            );
          },
          child: bedTimeSch[0].repeatDays.contains('Thu')
              ? weekButton('T', true)
              : weekButton('T', false),
        );
        break;
      case 5:
        return InkWell(
          onTap: () async{
            bedTimeFri = !bedTimeFri;
            setState(() {
              /*bedTimeSch[0].repeatDays.contains('Fri')
                  ? bedTimeSch[0].repeatDays.removeWhere((element) => element == 'Fri')
                  : bedTimeSch[0].repeatDays.add('Fri');*/
              if(bedTimeSch[0].repeatDays.contains('Fri')){
                bedTimeSch[0].repeatDays.removeWhere((element) => element == 'Fri');
                notificationPlugin.cancelSingleNotification(bedTimeSch[0].id.hashCode);
              }else if(!bedTimeFri){
                bedTimeSch[0].repeatDays.add('Fri');
              }
              //bedTimeSch[0].repeatDays = bedTimeDay;
            });
            await updateBedTime(
              context,
              BedTimeModel(
                bedTime: bedTimeSch[0].bedTime,
                wakeUpTime: bedTimeSch[0].wakeUpTime,
                inBed: bedTimeSch[0].inBed,
                outBed: bedTimeSch[0].outBed,
                isActive: bedTimeSch[0].isActive,
                repeatDays: bedTimeSch[0].repeatDays,
              ),
            );
          },
          child: bedTimeSch[0].repeatDays.contains('Fri')
              ? weekButton('F', true)
              : weekButton('F', false),
        );
        break;
      case 6:
        return InkWell(
          onTap: () async{
            //bedTimeSat = !bedTimeSat;
            setState(() {
              /*bedTimeSch[0].repeatDays.contains('Sat')
                  ? bedTimeSch[0].repeatDays.removeWhere((element) => element == 'Sat')
                  : bedTimeSch[0].repeatDays.add('Sat');*/
              if(bedTimeSch[0].repeatDays.contains('Sat')){
                bedTimeSch[0].repeatDays.removeWhere((element) => element == 'Sat');
                notificationPlugin.cancelSingleNotification(bedTimeSch[0].id.hashCode);
              }else if(!bedTimeSat){
                bedTimeSch[0].repeatDays.add('Sat');
              }
              //bedTimeSch[0].repeatDays = bedTimeDay;
            });
            await updateBedTime(
              context,
              BedTimeModel(
                bedTime: bedTimeSch[0].bedTime,
                wakeUpTime: bedTimeSch[0].wakeUpTime,
                inBed: bedTimeSch[0].inBed,
                outBed: bedTimeSch[0].outBed,
                isActive: bedTimeSch[0].isActive,
                repeatDays: bedTimeSch[0].repeatDays,
              ),
            );
          },
          child: bedTimeSch[0].repeatDays.contains('Sat')
              ? weekButton('S', true)
              : weekButton('S', false),
        );
        break;
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final bedTimeProvider = Provider.of<CRUDModel>(context);
    return SafeArea(
      child: SingleChildScrollView(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        physics: ClampingScrollPhysics(),
        child: Container(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight,
          child: StreamBuilder(
            stream: bedTimeProvider.fetchBedTimeAsStream(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(!snapshot.hasData){
                return Center(child: CircularProgressIndicator());
              }
              bedTimeSch = snapshot.data.docs.map((doc) => BedTimeModel.fromMap(doc.data(), doc.id)).toList();
              if(bedTimeSch.length <= 0){
                print('new bedTime');
                bedTimeProvider.addBedTimeSchedule(BedTimeModel(
                  bedTime: Timestamp.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch),
                  wakeUpTime: Timestamp.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch),
                  inBed: 270,
                  outBed: 80,
                  isActive: toggleVal,
                  repeatDays: [],
                )).whenComplete((){
                  setState(() {

                  });
                });
              }else{
                print('old bed Time');
                print('id :' + bedTimeSch[0].id);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: scheduleSwitch(context),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          'Day Active',
                          style: Theme.of(context).textTheme.bodyText,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(30, 20, 0, 20),
                      height: 7.49 * SizeConfig.heightMultiplier,
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: ListView.separated(
                        separatorBuilder: (context, i) {
                          return SizedBox(
                            width: 20,
                          );
                        },
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, i){
                          return weekDays(i, context);
                        },
                        itemCount: 7,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: SleepPage(
                        bedTimeModel: bedTimeSch[0],
                        updateTime: updateBedTime,
                      ),
                    ),
                  ],
                );
              }
              return Center(child: CircularProgressIndicator());
            }
          ),
        ),
      ),
    );
  }
}

class SleepPage extends StatefulWidget {
  @override
  _SleepPageState createState() => _SleepPageState();
  final BedTimeModel bedTimeModel;
  final Function updateTime;

  SleepPage({this.bedTimeModel, this.updateTime});
}

class _SleepPageState extends State<SleepPage> {
  final baseColor = Color.fromRGBO(255, 255, 255, 0.3);

  /*int initTime;
  int endTime;*/

  int inBedTime;
  int outBedTime;

  DateTime date;
  DateTime inBedNotifyTime;
  DateTime outBedNotifyTime;

  @override
  void initState() {
    //checkPref();
    super.initState();
    inBedTime = widget.bedTimeModel.inBed;
    outBedTime = widget.bedTimeModel.outBed;
    date = DateTime.now();
    //_shuffle();
  }

  /*checkPref() async{
    try{
      bool initBedExist = await SharedPrefs().checkPrefExists('initBed');
      bool initWakeUp = await SharedPrefs().checkPrefExists('outBed');
      if(initBedExist){
        print('in bed pref exists');
        inBedTime = await SharedPrefs().getIntPrefs('initBed');
      }else{
        print('in bed pref not exists');
        inBedTime = 270;
        await SharedPrefs().setIntPrefs('initBed', inBedTime);
      }

      if(initWakeUp){
        print('out bed pref exists');
        outBedTime = await SharedPrefs().getIntPrefs('outBed');
      }else{
        print('out bed pref not exists');
        outBedTime = 80;
        await SharedPrefs().setIntPrefs('outBed', outBedTime);
      }
      setState(() {

      });
    } catch(ex){
      print(ex);
    }
  }*/

  /*void _shuffle() {
    setState(() {
      //initTime = _generateRandomTime();
      //endTime = _generateRandomTime();
      inBedTime = 270;
      outBedTime = 80;
    });
  }*/

  void _updateLabels(int init, int end, int i) async{
    setState(() {
      inBedTime = init;
      outBedTime = end;
    });
    await widget.updateTime(
      context,
      BedTimeModel(
        bedTime: Timestamp.fromMillisecondsSinceEpoch(inBedNotifyTime.millisecondsSinceEpoch),
        wakeUpTime: Timestamp.fromMillisecondsSinceEpoch(outBedNotifyTime.millisecondsSinceEpoch),
        inBed: init,
        outBed: end,
        isActive: widget.bedTimeModel.isActive,
        repeatDays: widget.bedTimeModel.repeatDays,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8 * SizeConfig.widthMultiplier),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _formatBedTime('Bedtime', inBedTime),
              _formatBedTime('Wake Up', outBedTime),
            ],
          ),
        ),
        SizedBox(height: 1.4 * SizeConfig.heightMultiplier,),
        Flexible(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 17 * SizeConfig.widthMultiplier),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  /*child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kClockRing,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kGreyColor,
                          boxShadow: [
                            BoxShadow(
                              color: kShadowColor,
                              blurRadius: 5,
                            ),
                          ]
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.6 * SizeConfig.widthMultiplier),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kPurpleColor,
                            boxShadow: [
                              BoxShadow(
                                color: kShadowColor,
                                blurRadius: 5,
                              ),
                            ]
                        ),
                      ),
                    ],
                  ),*/
                  child: Transform.rotate(
                    angle: -pi / 2,
                    child: CustomPaint(
                      painter: BedTimePainter(),
                    ),
                  ),
                ),
                FittedBox(
                  child: Text(
                    'HR',
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bedTimeHr,
                  ),
                ),
                AspectRatio(
                  aspectRatio: 1,
                  child: DoubleCircularSlider(
                    288,
                    inBedTime,
                    outBedTime,
                    height: 260.0,
                    width: 260.0,
                    primarySectors: 6,
                    secondarySectors: 24,
                    baseColor: Colors.transparent,
                    selectionColor: kPurpleColor,
                    handlerColor: Colors.white,
                    handlerOutterRadius: 12.0,
                    onSelectionChange: _updateLabels,
                    sliderStrokeWidth: 12.0,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 11 * SizeConfig.widthMultiplier),
                        child: Center(
                            child: Text(
                                '${_formatIntervalTime(inBedTime, outBedTime)}',
                                style: Theme.of(context).textTheme.bedTime),),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _formatBedTime(String label, int time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyText,
        ),
        label == 'Bedtime' ? Text(
          '${_formatInBedTime(label, time)}',
          style: Theme.of(context).textTheme.bodyText,
        ) : Text(
          '${_formatWakeUpTime(label, time)}',
          style: Theme.of(context).textTheme.bodyText,
        ),
      ],
    );
  }

  String _formatInBedTime(String label, int time) {
    print('bed Time : ' + time.toString());
    if (time == 0 || time == null) {
      return '00:00';
    }
    var meridiem;
    var hours = time ~/ 12;
    var notifyTime = time ~/ 24;
    var minutes = (time % 12) * 5;
    if(hours == 0 || hours <= 12){
      meridiem = 'AM';
    }else{
      meridiem = 'PM';
    }
    print('Hours : ' + hours.toString());
    print('Notify Time : ' + notifyTime.toString());
    var stringTime = hours;
    print(date.year.toString());
    inBedNotifyTime = DateFormat('yyyy/MM/dd').add_Hm().parse(
        '${date.year.toString()}/${date.month.toString().padLeft(2, '0')}/'
            '${date.day.toString().padLeft(2, '0')} $stringTime:00'
    );
    /*DateTime inTheBed = new DateFormat("yyyy-MM-dd hh:mm").parse(
        '${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-'
            '${date.day.toString().padLeft(2, '0')} $stringTime:00 $meridiem');*/
    /*widget.updateTime(
      context,
      BedTimeModel(
        bedTime: Timestamp.fromMillisecondsSinceEpoch(bedTime.millisecondsSinceEpoch),
        wakeUpTime: widget.bedTimeModel.wakeUpTime,
        inBed: widget.bedTimeModel.inBed,
        outBed: widget.bedTimeModel.outBed,
        isActive: widget.bedTimeModel.isActive,
        repeatDays: widget.bedTimeModel.repeatDays,
      ),
    );*/
    /*if(label == 'Bedtime'){
      print('bedTime label');

      //SharedPrefs().setIntPrefs('BedTime', bedTime.millisecondsSinceEpoch);
    }else if(label == 'Wake Up'){
      DateTime wakeUpTime = new DateFormat("yyyy-MM-dd HH:mm a").parse(
          '${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-'
              '${date.day.toString().padLeft(2, '0')} $stringTime:00 $meridiem');
      widget.updateTime(
        context,
        BedTimeModel(
          bedTime: widget.bedTimeModel.bedTime,
          wakeUpTime: Timestamp.fromMillisecondsSinceEpoch(wakeUpTime.millisecondsSinceEpoch),
          inBed: widget.bedTimeModel.inBed,
          outBed: widget.bedTimeModel.outBed,
          isActive: widget.bedTimeModel.isActive,
          repeatDays: widget.bedTimeModel.repeatDays,
        ),
      );
      //SharedPrefs().setIntPrefs('WakeUpTime', wakeUpTime.millisecondsSinceEpoch);
    }*/
    print('time : ' + time.toString());
    print('in bed time : ' + inBedNotifyTime.toString());
    print('in bed time' + DateFormat.yMEd().add_jms().format(inBedNotifyTime).toString());
    return '$hours:00 $meridiem';
  }

  String _formatWakeUpTime(String label, int time) {
    print('Wake up Time : ' + time.toString());
    if (time == 0 || time == null) {
      return '00:00';
    }
    var meridiem;
    var hours = time ~/ 12;
    var minutes = (time % 12) * 5;
    if(hours == 0 || hours <= 12){
      meridiem = 'AM';
    }else{
      meridiem = 'PM';
    }
    var stringTime = hours;
    outBedNotifyTime = DateFormat('yyyy/MM/dd').add_Hm().parse(
        '${date.year.toString()}/${date.month.toString().padLeft(2, '0')}/'
            '${date.day.toString().padLeft(2, '0')} $stringTime:00'
    );
    /*DateTime outOfBed = new DateFormat("yyyy-MM-dd HH:mm").parse(
        '${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-'
            '${date.day.toString().padLeft(2, '0')} $stringTime:00');*/
    /*widget.updateTime(
      context,
      BedTimeModel(
        bedTime: widget.bedTimeModel.bedTime,
        wakeUpTime: Timestamp.fromMillisecondsSinceEpoch(wakeUpTime.millisecondsSinceEpoch),
        inBed: widget.bedTimeModel.inBed,
        outBed: widget.bedTimeModel.outBed,
        isActive: widget.bedTimeModel.isActive,
        repeatDays: widget.bedTimeModel.repeatDays,
      ),
    );*/
    /*if(label == 'Bedtime'){
      print('bedTime label');
      DateTime bedTime = new DateFormat("yyyy-MM-dd HH:mm a").parse(
          '${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-'
              '${date.day.toString().padLeft(2, '0')} $stringTime:00 $meridiem');
      widget.updateTime(
        context,
        BedTimeModel(
          bedTime: Timestamp.fromMillisecondsSinceEpoch(bedTime.millisecondsSinceEpoch),
          wakeUpTime: widget.bedTimeModel.wakeUpTime,
          inBed: widget.bedTimeModel.inBed,
          outBed: widget.bedTimeModel.outBed,
          isActive: widget.bedTimeModel.isActive,
          repeatDays: widget.bedTimeModel.repeatDays,
        ),
      );
      //SharedPrefs().setIntPrefs('BedTime', bedTime.millisecondsSinceEpoch);
    }else if(label == 'Wake Up'){

      //SharedPrefs().setIntPrefs('WakeUpTime', wakeUpTime.millisecondsSinceEpoch);
    }*/
    print('time : ' + time.toString());
    //print(tempDate);
    return '$hours:00 $meridiem';
  }

  String _formatIntervalTime(int init, int end) {
    var sleepTime = end > init ? end - init : 288 - init + end;
    var hours = sleepTime ~/ 12;
    var minutes = (sleepTime % 12) * 5;
    return hours.toString();
  }

  int _generateRandomTime() => Random().nextInt(288);
}
