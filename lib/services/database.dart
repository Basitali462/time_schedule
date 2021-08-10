/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_scheduler/models/alarm_model.dart';

class DataBaseService{

  final CollectionReference alarmCollection = FirebaseFirestore.instance.collection('alarms');

  Future addAlarm(String repeatDay, bool status, Timestamp time) async{
    return await alarmCollection.add({
      'RepeatDays': repeatDay,
      'Status': status,
      'AlarmTime': time,
    });
  }

  //get alarm list
  List<ModelAlarm> alarmListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) {
      return ModelAlarm(
        alarmTime: doc.data()['AlarmTime'].toDate() ?? '',
        isActive: doc.data()['Status'] ?? '',
        repeatDays: doc.data()['RepeatDays'] ?? '',
      );
    }).toList();
  }

  Stream<List<ModelAlarm>> get alarms{
    return alarmCollection.snapshots().map(alarmListFromSnapshot);
  }

  */
/*Future updateUserData(String title) async{
    return await alarmCollection.doc().set({
      'Title': title,
    });
  }*//*

}*/
