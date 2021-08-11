import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_scheduler/config/size_config.dart';
import 'package:time_scheduler/config/size_configuration.dart';
import 'package:time_scheduler/constants/constant_colors.dart';
import 'package:time_scheduler/constants/inner_shadow.dart';
import 'package:time_scheduler/constants/app_theme.dart';
import 'package:time_scheduler/models/alarm_model.dart';
import 'package:time_scheduler/models/crud_model.dart';
import 'package:time_scheduler/screens/pages/alarm_cards.dart';
import 'package:time_scheduler/services/database.dart';
import 'package:time_scheduler/services/notification_plugin.dart';

class Alarm extends StatefulWidget {
  @override
  _AlarmState createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {

  List<ModelAlarm> alarms;

  @override
  Widget build(BuildContext context) {
    final alarmProvider = Provider.of<CRUDModel>(context);
    return StreamBuilder(
      stream: alarmProvider.fetchAlarmAsStream(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(!snapshot.hasData || snapshot.data.docs.isEmpty){
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.alarm_add,
                  size: 60,
                  color: kYellowColor,
                ),
                SizedBox(height: 20,),
                Text(
                  'No Alarm Added',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kPurpleColor,
                  ),
                ),
              ],
            ),
          );
        }
        alarms = snapshot.data.docs.map((doc) => ModelAlarm.fromMap(doc.data(), doc.id)).toList();
        return ListView.separated(
            separatorBuilder: (context, i) {
              return SizedBox(
                height: getProportionateScreenHeight(20),
              );
            },
            padding: EdgeInsets.all(32),
            itemCount: alarms.length,
            itemBuilder: (context, i) {
              return AlarmCard(alarmDetail: alarms[i],);
            });
      }
    );
  }
}
