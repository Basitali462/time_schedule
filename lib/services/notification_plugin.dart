import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/standalone.dart' as tz;

class NotificationPlugin{
  FlutterLocalNotificationsPlugin localNotificationsPlugin;
  final BehaviorSubject<ReceivedNotification>
  didReceiveLocalNotification = BehaviorSubject<ReceivedNotification>();
  var initSettings;
  
  NotificationPlugin._(){
    init();
  }
  
  init() async{
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if(Platform.isIOS){
      requestPermission();
    }
    initPlatformSpec();
  }

  tz.TZDateTime instanceOfTime(DateTime time, var loc){
    final tz.TZDateTime now = tz.TZDateTime.now(loc);
    tz.TZDateTime scheduleTime = tz.TZDateTime.from(time, loc);
    if(scheduleTime.isBefore(now)){
      scheduleTime = scheduleTime.add(Duration(days: 1));
    }
    return scheduleTime;
  }

  Future<String> _getLocalTimeZone() async {
    tz.initializeTimeZones();
    String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    // return tz.setLocalLocation(tz.getLocation(timeZoneName));
    return timeZoneName;
  }

  Future<tz.Location> _getLocation(String location) async {
    return tz.getLocation(location);
  }
  
  initPlatformSpec(){
    var initAndroidSettings = AndroidInitializationSettings('defaultIcon');
    var initIosSettings = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async{
        ReceivedNotification receivedNotification = ReceivedNotification(
          id: id,
          title: title,
          body: body,
          payload: payload,
        );
        didReceiveLocalNotification.add(receivedNotification);
      }
    );

    initSettings = InitializationSettings(
      android: initAndroidSettings,
      iOS: initIosSettings,
    );
  }

  setListenerForLowerVersion(Function onNotificationInLowerVersion){
    didReceiveLocalNotification.listen((receivedNotification) {
      onNotificationInLowerVersion(receivedNotification);
    });
  }

  setOnNotificationClick(Function onNotificationClick){
    localNotificationsPlugin.initialize(
        initSettings,
        onSelectNotification: (String payload) async{
          onNotificationClick(payload);
        }
    );
  }
  
  requestPermission(){
    localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  //Simple Notification
  /*Future<void> showNotification() async{
    var androidChannelSpecs = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      'CHANNEL_DESC',
      sound: RawResourceAndroidNotificationSound('full_of_love_romantic_alarm'),
    );
    var iosChannelSpecs = IOSNotificationDetails(
      sound: 'full_of_love_romantic_alarm.mp3',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    var platfromChannelSpecs = NotificationDetails(
      android: androidChannelSpecs,
      iOS: iosChannelSpecs,
    );
    print('show notification');
    await localNotificationsPlugin.show(
      0,
      'Alarm',
      'Alarm Body',
      platfromChannelSpecs,
      payload: 'AlarmPayLoad'
    );
  }*/

  //Schedule Notification
  Future<void> scheduleNotification(int id ,DateTime time,) async{
    String timeZoneName = await _getLocalTimeZone();
    var location = await _getLocation(timeZoneName);
    var androidChannelSpecs = AndroidNotificationDetails(
      'CHANNEL_ID 1',
      'CHANNEL_NAME 1',
      'CHANNEL_DESC 1',
      sound: RawResourceAndroidNotificationSound('vip-siren'),
    );
    var iosChannelSpecs = IOSNotificationDetails(
      sound: 'vip-siren.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    var platfromChannelSpecs = NotificationDetails(
      android: androidChannelSpecs,
      iOS: iosChannelSpecs,
    );
    await localNotificationsPlugin.zonedSchedule(
      id,
      'Alarm',
      'Alarm Body',
      instanceOfTime(time, location),
      platfromChannelSpecs,
      payload: 'AlarmPayLoad',
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  //Repeated Notification
  /*Future<void> repeatedNotification() async{
    var androidChannelSpecs = AndroidNotificationDetails(
      'CHANNEL_ID 2',
      'CHANNEL_NAME 2',
      'CHANNEL_DESC 2',
      sound: RawResourceAndroidNotificationSound('vip-siren'),
    );
    var iosChannelSpecs = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      sound: 'vip-siren.wav',
      presentSound: true,
    );
    var platfromChannelSpecs = NotificationDetails(
      android: androidChannelSpecs,
      iOS: iosChannelSpecs,
    );
    await localNotificationsPlugin.periodicallyShow(
      0,
      'Alarm',
      'Alarm Body',
      RepeatInterval.everyMinute,
      platfromChannelSpecs,
      payload: 'AlarmPayLoad',
    );
  }*/

  //Repeated Schedule Notification
  Future<void> repeatAtSpecificTimeNotification(int id, DateTime time, DateTimeComponents components) async{
    //var time = Time(int.parse(DateFormat('hh').format(notifyTime)));
    //print(time);
    String timeZoneName = await _getLocalTimeZone();
    var location = await _getLocation(timeZoneName);
    var androidChannelSpecs = AndroidNotificationDetails(
      'CHANNEL_ID 1',
      'CHANNEL_NAME 1',
      'CHANNEL_DESC 1',
      sound: RawResourceAndroidNotificationSound('vip-siren'),
    );
    var iosChannelSpecs = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      sound: 'vip-siren.wav',
      presentSound: true,
    );
    var platfromChannelSpecs = NotificationDetails(
      android: androidChannelSpecs,
      iOS: iosChannelSpecs,
    );
    await localNotificationsPlugin.zonedSchedule(
      id,
      'Alarm',
      'Alarm Body',
      tz.TZDateTime.from(time, location),
      platfromChannelSpecs,
      payload: 'AlarmPayLoad',
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: components,
    );
  }

  //get pending notifications
  Future<int> getPendingNotificationCount() async {
    List<PendingNotificationRequest> pendingNotification =
        await localNotificationsPlugin.pendingNotificationRequests();
    return pendingNotification.length;
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async{
    List<PendingNotificationRequest> pendingNotification =
    await localNotificationsPlugin.pendingNotificationRequests();
    return pendingNotification;
  }

  //cancel with id notification
  Future<void> cancelSingleNotification(int id) async{
    List<PendingNotificationRequest> pendingReq = await getPendingNotifications();
    for(int i = 0; i < pendingReq.length; i++){
      print('pending req' + pendingReq[i].id.toString());
      if(pendingReq[i].id == id){
        print('canceling notification');
        await localNotificationsPlugin.cancel(pendingReq[i].id);
      }else if(pendingReq[i].id == id + 1){
        print('canceling notification 1');
        await localNotificationsPlugin.cancel(pendingReq[i].id);
      }else if(pendingReq[i].id == id + 2){
        print('canceling notification 2');
        await localNotificationsPlugin.cancel(pendingReq[i].id);
      }else if(pendingReq[i].id == id + 3){
        print('canceling notification 3');
        await localNotificationsPlugin.cancel(pendingReq[i].id);
      }else if(pendingReq[i].id == id + 4){
        print('canceling notification 4');
        await localNotificationsPlugin.cancel(pendingReq[i].id);
      }else if(pendingReq[i].id == id + 5){
        print('canceling notification 5');
        await localNotificationsPlugin.cancel(pendingReq[i].id);
      }else if(pendingReq[i].id == id + 6){
        print('canceling notification 6');
        await localNotificationsPlugin.cancel(pendingReq[i].id);
      }else if(pendingReq[i].id == id + 7){
        print('canceling notification 7');
        await localNotificationsPlugin.cancel(pendingReq[i].id);
      }else if(pendingReq[i].id == id + 8){
        print('canceling notification 8');
        await localNotificationsPlugin.cancel(pendingReq[i].id);
      }else if(pendingReq[i].id == id + 9){
        print('canceling notification 9');
        await localNotificationsPlugin.cancel(pendingReq[i].id);
      }else if(pendingReq[i].id == id + 10){
        print('canceling notification 10');
        await localNotificationsPlugin.cancel(pendingReq[i].id);
      }else if(pendingReq[i].id == id + 11){
        print('canceling notification 11');
        await localNotificationsPlugin.cancel(pendingReq[i].id);
      }else if(pendingReq[i].id == id + 12){
        print('canceling notification 12');
        await localNotificationsPlugin.cancel(pendingReq[i].id);
      }else if(pendingReq[i].id == id + 13){
        print('canceling notification 13');
        await localNotificationsPlugin.cancel(pendingReq[i].id);
      }else if(pendingReq[i].id == id + 14){
        print('canceling notification 14');
        await localNotificationsPlugin.cancel(pendingReq[i].id);
      }
    }
  }

  //cancel notification
  Future<void> cancelNotification() async{
    await localNotificationsPlugin.cancelAll();
  }

}

NotificationPlugin notificationPlugin = NotificationPlugin._();

class ReceivedNotification{
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
});
}