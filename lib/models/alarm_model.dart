import 'package:cloud_firestore/cloud_firestore.dart';

class ModelAlarm{
  String id;
  Timestamp alarmTime;
  bool isActive;
  List<dynamic> repeatDays;

  ModelAlarm({this.alarmTime, this.isActive, this.repeatDays});

  ModelAlarm.fromMap(Map snapshot, String id) :
      id = id ?? '',
      alarmTime = snapshot['alarmTime'] ?? '',
      isActive = snapshot['isActive'] ?? '',
      repeatDays =  List<String>.from(snapshot['repeatDays']) ?? [];
  toJson(){
    return{
      'alarmTime': alarmTime,
      'isActive': isActive,
      'repeatDays': repeatDays,
    };
  }
}