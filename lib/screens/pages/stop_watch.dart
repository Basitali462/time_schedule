import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:time_scheduler/config/size_config.dart';
import 'package:time_scheduler/config/size_configuration.dart';
import 'package:time_scheduler/constants/constant_colors.dart';
import 'package:time_scheduler/constants/app_theme.dart';

class StopWatchPage extends StatefulWidget {
  @override
  _StopWatchPageState createState() => _StopWatchPageState();
}

class _StopWatchPageState extends State<StopWatchPage> {

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final _scrollController = ScrollController();

  List lapTime = [];
  bool _isStarted = false;

  @override
  void initState() {
    // TODO: implement initState
    Timer.periodic(Duration(microseconds: 1), (timer) {
      if(mounted){
        setState(() {
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _stopWatchTimer.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: StreamBuilder(
              stream: _stopWatchTimer.rawTime,
              initialData: 0,
              builder: (context, snapshot) {
                final value = snapshot.data;
                final displayTime =
                    StopWatchTimer.getDisplayTime(value);
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(16)),
                  child: FittedBox(
                    child: Text(
                      displayTime,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.clockText,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.5 * SizeConfig.widthMultiplier),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                child: Container(
                  alignment: Alignment.center,
                  width: 26.6 * SizeConfig.widthMultiplier,
                  height: 7.4 * SizeConfig.heightMultiplier,
                  decoration: BoxDecoration(
                    color: kGreyColor,
                    border: Border.all(
                      width: 0.5 * SizeConfig.widthMultiplier,
                      color: kWhiteColor,
                    ),
                    borderRadius: BorderRadius.circular(1.7 * SizeConfig.heightMultiplier),
                    boxShadow: [
                      BoxShadow(
                          color: kInnerShadow,
                          blurRadius: 1,
                          spreadRadius: 0.5
                      ),
                    ],
                  ),
                  child: Text(
                    'Reset',
                    style: Theme.of(context).textTheme.stopWatchBody,
                  ),
                ),
                onTap: (){
                  _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                  setState(() {
                    _isStarted = false;
                  });
                },
              ),
              InkWell(
                child: Container(
                  alignment: Alignment.center,
                  width: 26.6 * SizeConfig.widthMultiplier,
                  height: 7.4 * SizeConfig.heightMultiplier,
                  decoration: BoxDecoration(
                    color: _isStarted ? kGreyColor : kYellowColor,
                    border: Border.all(
                      width: 0.5 * SizeConfig.widthMultiplier,
                      color: kWhiteColor,
                    ),
                    borderRadius: BorderRadius.circular(1.7 * SizeConfig.heightMultiplier),
                    boxShadow: [
                      BoxShadow(
                          color: kInnerShadow,
                          blurRadius: 1,
                          spreadRadius: 0.5
                      ),
                    ],
                  ),
                  child: Text(
                    _isStarted ? 'Stop' : 'Start',
                    style: Theme.of(context).textTheme.stopWatchBody,
                  ),
                ),
                onTap: (){
                  if(_isStarted){
                    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                    setState(() {
                      _isStarted = false;
                    });
                  }else{
                    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                    setState(() {
                      _isStarted = true;
                    });
                  }
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 1.4 * SizeConfig.heightMultiplier,),
        InkWell(
          child: Container(
            alignment: Alignment.center,
            width: 26.6 * SizeConfig.widthMultiplier,
            height: 7.4 * SizeConfig.heightMultiplier,
            decoration: BoxDecoration(
              color: kYellowColor,
              border: Border.all(
                width: 0.5 * SizeConfig.widthMultiplier,
                color: kWhiteColor,
              ),
              borderRadius: BorderRadius.circular(1.7 * SizeConfig.heightMultiplier),
              boxShadow: [
                BoxShadow(
                    color: kInnerShadow,
                    blurRadius: 2,
                    spreadRadius: 0.5
                ),
              ],
            ),
            child: Text(
              'Lap',
              style: Theme.of(context).textTheme.stopWatchBody,
            ),
          ),
          onTap: (){
            _stopWatchTimer.onExecute.add(StopWatchExecute.lap);
          },
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 2.3 * SizeConfig.heightMultiplier),
            child: StreamBuilder(
              stream: _stopWatchTimer.records,
              initialData: [],
              builder: (context, snapshot){
                final value = snapshot.data;
                lapTime = value;
                if(!snapshot.hasData){
                  return Container(

                  );
                }
                /*Future.delayed(Duration(milliseconds: 100), (){
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                  );
                });*/
                return ListView.separated(
                  controller: _scrollController,
                  reverse: true,
                  shrinkWrap: true,
                  separatorBuilder: (context, i){
                    return SizedBox(height: 3 * SizeConfig.heightMultiplier,);
                  },
                  itemCount: lapTime.length,
                  itemBuilder: (context, i){
                    final data = lapTime[i];
                    return Slidable(
                      actionExtentRatio: 0.2,
                      actionPane: SlidableDrawerActionPane(),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 6.4 * SizeConfig.widthMultiplier),
                        padding: EdgeInsets.symmetric(vertical: 2.3 * SizeConfig.heightMultiplier, horizontal: 4.2 * SizeConfig.widthMultiplier),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: kWhiteColor,
                              blurRadius: 2,
                              spreadRadius: 0.5
                            ),
                          ],
                          border: Border.all(
                            width: 2,
                            color: kWhiteColor,
                          ),
                          borderRadius: BorderRadius.circular(1.7 * SizeConfig.heightMultiplier),
                          gradient: LinearGradient(
                              colors: [kGreyColor, kDimOutline],
                              begin: Alignment(0, 0),
                              end: Alignment(10, 10)
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Lap ${i+1}',
                              style: Theme.of(context).textTheme.stopWatchBody,
                            ),
                            Text(
                              data.displayTime,
                              style: Theme.of(context).textTheme.lapTime,
                            ),
                          ],
                        ),
                      ),
                      secondaryActions: [
                        IconSlideAction(
                          color: Colors.transparent,
                          iconWidget: Icon(
                            Icons.delete,
                            color: kRedColor,
                          ),
                          onTap: (){
                            lapTime.removeAt(i);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
