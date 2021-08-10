import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:time_scheduler/constants/setNotificatiion.dart';
import 'package:time_scheduler/models/alarm_model.dart';
import 'package:time_scheduler/models/bed_time_model.dart';
import 'package:time_scheduler/services/api.dart';
import 'package:time_scheduler/services/notification_plugin.dart';
import '../locator.dart';
import 'package:flutter/material.dart';

class CRUDModel extends ChangeNotifier {
  Api api = locator<Api>();

  List<ModelAlarm> alarm;
  List<BedTimeModel> bedTime;

  Future<List<ModelAlarm>> fetchAlarm() async{
    var result = await api.getDataCollection();
    alarm = result.docs.map((doc) => ModelAlarm.fromMap(doc.data(), doc.id)).toList();
    return alarm;
  }

  Stream<QuerySnapshot> fetchAlarmAsStream(){
    return api.streamDataCollection();
  }

  Future removeAlarm(String id) async{
    await api.removeDoc(id);
    return ;
  }

  Future addAlarm(ModelAlarm data) async{
    var result = await api.addDoc(data.toJson());
    print(result.id);
    //await convertToInt(result.id);
    int notifyId = result.id.hashCode;
    print('set id of alarm' + notifyId.toString());
    await SetNotifications().settingAlarmNotifications(notifyId, data);
    return ;
  }

  /*Future convertToInt(String alarmId) async{
    int id = int.tryParse(alarmId);
    print(id);
  }*/

  Future updateAlarm(ModelAlarm data, String id) async{
    await api.updateDoc(data.toJson(), id);
    int notifyId = id.hashCode;
    print('set id of alarm' + notifyId.toString());
    await SetNotifications().settingAlarmNotifications(notifyId, data);
    return ;
  }

  //---------------BedTime Schedule Manager-------------------
  Future addBedTimeSchedule(BedTimeModel data) async{
    var result = await api.addBedTimeDoc(data.toJson());
    /*print(result.id);
    //await convertToInt(result.id);
    int notifyId = result.id.hashCode;
    print('set id of bed Time alarm' + notifyId.toString());*/
    //await SetNotifications().settingNotifications(notifyId, data);
    return ;
  }

  Stream<QuerySnapshot> fetchBedTimeAsStream(){
    return api.streamDataBedTimeCollection();
  }

  Future updateBedTimeSchedule(BedTimeModel data, String id) async{
    await api.updateBedTimeDoc(data.toJson(), id);
    int notifyId = id.hashCode;
    print('set id of bedTime alarm' + notifyId.toString());
    await SetNotifications().settingBedTimeNotification(notifyId, data);
    await SetNotifications().settingWakeUpTimeNotification(notifyId, data);
    return ;
  }
}