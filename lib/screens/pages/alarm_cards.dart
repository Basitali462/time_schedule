import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_scheduler/config/size_config.dart';
import 'package:time_scheduler/config/size_configuration.dart';
import 'package:time_scheduler/constants/constant_colors.dart';
import 'package:time_scheduler/constants/inner_shadow.dart';
import 'package:time_scheduler/models/alarm_model.dart';
import 'package:time_scheduler/constants/app_theme.dart';
import 'package:time_scheduler/models/crud_model.dart';
import 'package:time_scheduler/services/notification_plugin.dart';

class AlarmCard extends StatefulWidget {

  final ModelAlarm alarmDetail;

  AlarmCard({this.alarmDetail});

  @override
  _AlarmCardState createState() => _AlarmCardState();
}

class _AlarmCardState extends State<AlarmCard> {

  bool toggleVal;

  @override
  Widget build(BuildContext context) {
    final alarmProvider = Provider.of<CRUDModel>(context);
    return Slidable(
      actionExtentRatio: 0.2,
      actionPane: SlidableDrawerActionPane(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(getProportionateScreenHeight(48)),
                gradient: LinearGradient(
                  colors: [widget.alarmDetail.isActive ? kYellowColor : kShadowColor, kGreyColor],
                  begin: Alignment(1.0, 1.0),
                  end: Alignment(-1.7, -1.7),
                ),
                border: Border.all(
                  width: 2,
                  color: widget.alarmDetail.isActive ? Colors.transparent : kWhiteColor,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    top: getProportionateScreenHeight(32)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(12)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Text(
                              widget.alarmDetail.repeatDays.join(', '),
                              textAlign: TextAlign.center,
                              style:
                              Theme.of(context).textTheme.alarmDays,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(20),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.widthMultiplier),
                          child: FittedBox(
                            child: Text(
                              '${DateFormat('a').format((widget.alarmDetail.alarmTime).toDate()).toString()}',
                              maxLines: 1,
                              style:
                              Theme.of(context).textTheme.alarmMed,
                            ),
                          ),
                        ),
                        Text(
                          '${DateFormat('hh:mm').format((widget.alarmDetail.alarmTime).toDate()).toString()}',
                          style:
                          Theme.of(context).textTheme.clockText,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 3 * SizeConfig.heightMultiplier,
          ),
          Flexible(
            flex: 1,
            child: InnerShadow(
              blur: 5,
              color: kInnerShadow,
              offset: Offset(1, 1),
              child: Container(
                width: 22 * SizeConfig.widthMultiplier,
                height: 18 * SizeConfig.heightMultiplier,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      6 * SizeConfig.heightMultiplier),
                  color: kGreyColor,
                  border: Border.all(
                      width: 0.8 * SizeConfig.widthMultiplier,
                      color: kDimOutline),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 0.5 * SizeConfig.heightMultiplier,),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                        bottom: widget.alarmDetail.isActive
                            ? 6 * SizeConfig.heightMultiplier
                            : 0,
                        //top: toggleVal ? 0 : 6.5 * SizeConfig.heightMultiplier,
                        child: InkWell(
                          onTap: () async{
                            setState(() {
                              toggleVal = !widget.alarmDetail.isActive;
                            });
                            await alarmProvider.updateAlarm(ModelAlarm(
                              //notifyId: widget.alarmDetail.notifyId,
                              alarmTime: widget.alarmDetail.alarmTime,
                              isActive: toggleVal,
                              repeatDays: widget.alarmDetail.repeatDays
                            ), widget.alarmDetail.id);
                          },
                          child: Container(
                            width: 18.5 * SizeConfig.widthMultiplier,
                            height: 9.7 * SizeConfig.heightMultiplier,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: widget.alarmDetail.isActive
                                  ? LinearGradient(
                                colors: [
                                  kYellowColor,
                                  kYellowColor
                                ],
                                begin: Alignment(0, 0),
                                end: Alignment(1, 1),
                              )
                                  : LinearGradient(
                                colors: [
                                  kPurpleColor,
                                  kGreyColor
                                ],
                                begin: Alignment(0.1, 0.3),
                                end: Alignment(-1.7, 0),
                              ),
                            ),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  widget.alarmDetail.isActive ? 'ON' : 'OFF',
                                  style: TextStyle(
                                    color: widget.alarmDetail.isActive
                                        ? kPurpleColor
                                        : kGreyColor,
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
        ],
      ),
      secondaryActions: [
        IconSlideAction(
          color: Colors.transparent,
          iconWidget: Icon(
            Icons.delete,
            color: kRedColor,
            size: 32,
          ),
          onTap: () async{
            await notificationPlugin.cancelSingleNotification(widget.alarmDetail.id.hashCode);
            await alarmProvider.removeAlarm(widget.alarmDetail.id);
            print(widget.alarmDetail.id.hashCode);
            int count = await notificationPlugin.getPendingNotificationCount();
            print(count);
          },
        ),
      ],
    );
  }
}
