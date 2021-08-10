import 'package:cloud_firestore/cloud_firestore.dart';

class BedTimeModel{
  String id;
  Timestamp bedTime;
  Timestamp wakeUpTime;
  int inBed;
  int outBed;
  bool isActive;
  List<dynamic> repeatDays;

  BedTimeModel({this.bedTime, this.wakeUpTime, this.inBed, this.outBed, this.isActive, this.repeatDays});

  BedTimeModel.fromMap(Map snapshot, String id) :
        id = id ?? '',
        bedTime = snapshot['bedTime'] ?? '',
        wakeUpTime = snapshot['wakeUpTime'] ?? '',
        inBed = snapshot['inBed'] ?? '',
        outBed = snapshot['outBed'] ?? '',
        isActive = snapshot['isActive'] ?? '',
        repeatDays =  List<String>.from(snapshot['repeatDays']) ?? [];
  toJson(){
    return{
      'bedTime': bedTime,
      'wakeUpTime': wakeUpTime,
      'inBed': inBed,
      'outBed': outBed,
      'isActive': isActive,
      'repeatDays': repeatDays,
    };
  }
}