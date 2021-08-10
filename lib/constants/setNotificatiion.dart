import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:time_scheduler/models/alarm_model.dart';
import 'package:time_scheduler/models/bed_time_model.dart';
import 'package:time_scheduler/services/notification_plugin.dart';

class SetNotifications{
  int notifyId;
  int bedTimeNotifyId;
  int wakeUpTimeNotifyId;
  Future settingAlarmNotifications(int id, ModelAlarm data) async{
    /*int id = data.notifyId;
    print(data.notifyId);*/
    print(data.repeatDays.length.toString());
    if(data.isActive == false && await notificationPlugin.getPendingNotificationCount() > 0){
      print('updating notification' + data.isActive.toString());
      await notificationPlugin.cancelSingleNotification(id);
      return ;
    }
    if(data.isActive && data.repeatDays.contains('Never')){
      await notificationPlugin.scheduleNotification(id, data.alarmTime.toDate());
      int count = await notificationPlugin.getPendingNotificationCount();
      print(count);
      return ;
    }
    if(data.isActive && data.repeatDays.contains('EveryDay')){
      print('setting everyday alarm');
      await notificationPlugin.repeatAtSpecificTimeNotification(
          id,
          data.alarmTime.toDate(),
          DateTimeComponents.time
      );
      int count = await notificationPlugin.getPendingNotificationCount();
      print(count);
      return ;
    }
    if(data.isActive && data.repeatDays.length >= 1){
      print('set week oof day alarm' + data.repeatDays.length.toString());
      DateTime weekTime = data.alarmTime.toDate();
      /*weekTime = weekTime.add(Duration(days: 4));
      print(DateFormat('EE').format(weekTime));
      print(weekTime.day);
      print(weekTime.weekday);*/
      for(int i = 0; i < data.repeatDays.length; i++){
        print('repeat day #' + i.toString());
        if(data.repeatDays[i] == 'Mon'){
          notifyId = id + 1;
          print('Mon notify');
          if(weekTime.weekday > 1){
            await notificationPlugin.repeatAtSpecificTimeNotification(
                notifyId,
                weekTime.add(Duration(days: (7 + 1) - weekTime.weekday)),
                //data.alarmTime.toDate().add(Duration()),
                DateTimeComponents.dayOfWeekAndTime
            );
          }else if(weekTime.weekday == 1){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              notifyId,
              weekTime,
              DateTimeComponents.dayOfWeekAndTime,
            );
          }
        }else if(data.repeatDays[i] == 'Tue'){
          print('Tue notify');
          notifyId = id + 2;
          if(weekTime.weekday > 2){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              notifyId,
              weekTime.add(Duration(days: (7 + 2) - weekTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(weekTime.weekday < 2){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              notifyId,
              weekTime.add(Duration(days: 2 - weekTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(weekTime.weekday == 2){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              notifyId,
              weekTime,
              DateTimeComponents.dayOfWeekAndTime,
            );
          }
        }else if(data.repeatDays[i] == 'Wed'){
          print('Wed notify');
          notifyId = id + 3;
          if(weekTime.weekday > 3){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              notifyId,
              weekTime.add(Duration(days: (7 + 3) - weekTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(weekTime.weekday < 3){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              notifyId,
              weekTime.add(Duration(days: 3 - weekTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(weekTime.weekday == 3){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              notifyId,
              weekTime,
              DateTimeComponents.dayOfWeekAndTime,
            );
          }
        }else if(data.repeatDays[i] == 'Thu'){
          print('Thu notify');
          notifyId = id + 4;
          if(weekTime.weekday > 4){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              notifyId,
              weekTime.add(Duration(days: (7 + 4) - weekTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(weekTime.weekday < 4){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              notifyId,
              weekTime.add(Duration(days: 4 - weekTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(weekTime.weekday == 4){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              notifyId,
              weekTime,
              DateTimeComponents.dayOfWeekAndTime,
            );
          }
        }else if(data.repeatDays[i] == 'Fri'){
          print('Fri notify');
          notifyId = id + 5;
          if(weekTime.weekday > 5){
            print('weekday greater tha fri notify');
            await notificationPlugin.repeatAtSpecificTimeNotification(
              notifyId,
              weekTime.add(Duration(days: (7 + 5) - weekTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(weekTime.weekday < 5){
            print('weekday less than fri notify');
            await notificationPlugin.repeatAtSpecificTimeNotification(
              notifyId,
              weekTime.add(Duration(days: 5 - weekTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(weekTime.weekday == 5){
            print('weekday fri');
            await notificationPlugin.repeatAtSpecificTimeNotification(
              notifyId,
              weekTime,
              DateTimeComponents.dayOfWeekAndTime,
            );
          }
        }else if(data.repeatDays[i] == 'Sat'){
          print('Sat Notify');
          notifyId = id + 6;
          if(weekTime.weekday > 6){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              notifyId,
              weekTime.add(Duration(days: (7 + 6) - weekTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(weekTime.weekday < 6){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              notifyId,
              weekTime.add(Duration(days: 6 - weekTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(weekTime.weekday == 6){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              notifyId,
              weekTime,
              DateTimeComponents.dayOfWeekAndTime,
            );
          }
        }else if(data.repeatDays[i] == 'Sun'){
          print('Sun Notify');
          notifyId = id + 7;
          if(weekTime.weekday < 7){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              notifyId,
              weekTime.add(Duration(days: 7 - weekTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(weekTime.weekday == 7){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              notifyId,
              weekTime,
              DateTimeComponents.dayOfWeekAndTime,
            );
          }
        }
      }
      int count = await notificationPlugin.getPendingNotificationCount();
      print(count);
      return ;
    }
  }

  Future settingBedTimeNotification(int id, BedTimeModel data) async{
    if(data.isActive == false && await notificationPlugin.getPendingNotificationCount() > 0){
      print('updating notification' + data.isActive.toString());
      await notificationPlugin.cancelSingleNotification(id);
      return ;
    }
    if(data.isActive && data.repeatDays.length > 0){
      DateTime bedTime = data.bedTime.toDate();
      for(int i = 0; i < data.repeatDays.length; i++){
        print('repeat day #' + i.toString());
        if(data.repeatDays[i] == 'Mon'){
          bedTimeNotifyId = id + 1;
          print('Mon notify');
          if(bedTime.weekday > 1){
            await notificationPlugin.repeatAtSpecificTimeNotification(
                bedTimeNotifyId,
                bedTime.add(Duration(days: (7 + 1) - bedTime.weekday)),
                //data.alarmTime.toDate().add(Duration()),
                DateTimeComponents.dayOfWeekAndTime
            );
          }else if(bedTime.weekday == 1){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              bedTimeNotifyId,
              bedTime,
              DateTimeComponents.dayOfWeekAndTime,
            );
          }
        }else if(data.repeatDays[i] == 'Tue'){
          print('Tue notify bedtime');
          bedTimeNotifyId = id + 2;
          if(bedTime.weekday > 2){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              bedTimeNotifyId,
              bedTime.add(Duration(days: (7 + 2) - bedTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(bedTime.weekday < 2){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              bedTimeNotifyId,
              bedTime.add(Duration(days: 2 - bedTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(bedTime.weekday == 2){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              bedTimeNotifyId,
              bedTime,
              DateTimeComponents.dayOfWeekAndTime,
            );
          }
        }else if(data.repeatDays[i] == 'Wed'){
          print('Wed notify');
          bedTimeNotifyId = id + 3;
          if(bedTime.weekday > 3){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              bedTimeNotifyId,
              bedTime.add(Duration(days: (7 + 3) - bedTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(bedTime.weekday < 3){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              bedTimeNotifyId,
              bedTime.add(Duration(days: 3 - bedTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(bedTime.weekday == 3){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              bedTimeNotifyId,
              bedTime,
              DateTimeComponents.dayOfWeekAndTime,
            );
          }
        }else if(data.repeatDays[i] == 'Thu'){
          print('Thu notify');
          bedTimeNotifyId = id + 4;
          if(bedTime.weekday > 4){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              bedTimeNotifyId,
              bedTime.add(Duration(days: (7 + 4) - bedTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(bedTime.weekday < 4){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              bedTimeNotifyId,
              bedTime.add(Duration(days: 4 - bedTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(bedTime.weekday == 4){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              bedTimeNotifyId,
              bedTime,
              DateTimeComponents.dayOfWeekAndTime,
            );
          }
        }else if(data.repeatDays[i] == 'Fri'){
          print('Fri notify');
          bedTimeNotifyId = id + 5;
          if(bedTime.weekday > 5){
            print('weekday greater tha fri notify');
            await notificationPlugin.repeatAtSpecificTimeNotification(
              bedTimeNotifyId,
              bedTime.add(Duration(days: (7 + 5) - bedTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(bedTime.weekday < 5){
            print('weekday less than fri notify');
            await notificationPlugin.repeatAtSpecificTimeNotification(
              bedTimeNotifyId,
              bedTime.add(Duration(days: 5 - bedTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(bedTime.weekday == 5){
            print('weekday fri');
            await notificationPlugin.repeatAtSpecificTimeNotification(
              bedTimeNotifyId,
              bedTime,
              DateTimeComponents.dayOfWeekAndTime,
            );
          }
        }else if(data.repeatDays[i] == 'Sat'){
          print('Sat Notify');
          bedTimeNotifyId = id + 6;
          if(bedTime.weekday > 6){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              bedTimeNotifyId,
              bedTime.add(Duration(days: (7 + 6) - bedTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(bedTime.weekday < 6){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              bedTimeNotifyId,
              bedTime.add(Duration(days: 6 - bedTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(bedTime.weekday == 6){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              bedTimeNotifyId,
              bedTime,
              DateTimeComponents.dayOfWeekAndTime,
            );
          }
        }else if(data.repeatDays[i] == 'Sun'){
          print('Sun Notify');
          bedTimeNotifyId = id + 7;
          if(bedTime.weekday < 7){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              bedTimeNotifyId,
              bedTime.add(Duration(days: 7 - bedTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(bedTime.weekday == 7){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              bedTimeNotifyId,
              bedTime,
              DateTimeComponents.dayOfWeekAndTime,
            );
          }
        }
      }
      int count = await notificationPlugin.getPendingNotificationCount();
      print(count);
      return ;
    }
  }

  Future settingWakeUpTimeNotification(int id, BedTimeModel data) async{
    if(data.isActive == false && await notificationPlugin.getPendingNotificationCount() > 0){
      print('updating notification' + data.isActive.toString());
      await notificationPlugin.cancelSingleNotification(id);
      return ;
    }
    if(data.isActive && data.repeatDays.length > 0){
      DateTime wakeUpTime = data.wakeUpTime.toDate();
      for(int i = 0; i < data.repeatDays.length; i++){
        print('repeat day #' + i.toString());
        if(data.repeatDays[i] == 'Mon'){
          wakeUpTimeNotifyId = id + 8;
          print('Mon notify');
          if(wakeUpTime.weekday > 1){
            await notificationPlugin.repeatAtSpecificTimeNotification(
                wakeUpTimeNotifyId,
                wakeUpTime.add(Duration(days: (7 + 1) - wakeUpTime.weekday)),
                //data.alarmTime.toDate().add(Duration()),
                DateTimeComponents.dayOfWeekAndTime
            );
          }else if(wakeUpTime.weekday == 1){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              wakeUpTimeNotifyId,
              wakeUpTime,
              DateTimeComponents.dayOfWeekAndTime,
            );
          }
        }else if(data.repeatDays[i] == 'Tue'){
          print('Tue notify WakeUpTime');
          wakeUpTimeNotifyId = id + 9;
          if(wakeUpTime.weekday > 2){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              wakeUpTimeNotifyId,
              wakeUpTime.add(Duration(days: (7 + 2) - wakeUpTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(wakeUpTime.weekday < 2){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              wakeUpTimeNotifyId,
              wakeUpTime.add(Duration(days: 2 - wakeUpTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(wakeUpTime.weekday == 2){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              wakeUpTimeNotifyId,
              wakeUpTime,
              DateTimeComponents.dayOfWeekAndTime,
            );
          }
        }else if(data.repeatDays[i] == 'Wed'){
          print('Wed notify');
          wakeUpTimeNotifyId = id + 10;
          if(wakeUpTime.weekday > 3){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              wakeUpTimeNotifyId,
              wakeUpTime.add(Duration(days: (7 + 3) - wakeUpTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(wakeUpTime.weekday < 3){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              wakeUpTimeNotifyId,
              wakeUpTime.add(Duration(days: 3 - wakeUpTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(wakeUpTime.weekday == 3){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              wakeUpTimeNotifyId,
              wakeUpTime,
              DateTimeComponents.dayOfWeekAndTime,
            );
          }
        }else if(data.repeatDays[i] == 'Thu'){
          print('Thu notify');
          wakeUpTimeNotifyId = id + 11;
          if(wakeUpTime.weekday > 4){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              wakeUpTimeNotifyId,
              wakeUpTime.add(Duration(days: (7 + 4) - wakeUpTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(wakeUpTime.weekday < 4){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              wakeUpTimeNotifyId,
              wakeUpTime.add(Duration(days: 4 - wakeUpTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(wakeUpTime.weekday == 4){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              wakeUpTimeNotifyId,
              wakeUpTime,
              DateTimeComponents.dayOfWeekAndTime,
            );
          }
        }else if(data.repeatDays[i] == 'Fri'){
          print('Fri notify');
          wakeUpTimeNotifyId = id + 12;
          if(wakeUpTime.weekday > 5){
            print('weekday greater tha fri notify');
            await notificationPlugin.repeatAtSpecificTimeNotification(
              wakeUpTimeNotifyId,
              wakeUpTime.add(Duration(days: (7 + 5) - wakeUpTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(wakeUpTime.weekday < 5){
            print('weekday less than fri notify');
            await notificationPlugin.repeatAtSpecificTimeNotification(
              wakeUpTimeNotifyId,
              wakeUpTime.add(Duration(days: 5 - wakeUpTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(wakeUpTime.weekday == 5){
            print('weekday fri');
            await notificationPlugin.repeatAtSpecificTimeNotification(
              wakeUpTimeNotifyId,
              wakeUpTime,
              DateTimeComponents.dayOfWeekAndTime,
            );
          }
        }else if(data.repeatDays[i] == 'Sat'){
          print('Sat Notify');
          wakeUpTimeNotifyId = id + 13;
          if(wakeUpTime.weekday > 6){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              wakeUpTimeNotifyId,
              wakeUpTime.add(Duration(days: (7 + 6) - wakeUpTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(wakeUpTime.weekday < 6){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              wakeUpTimeNotifyId,
              wakeUpTime.add(Duration(days: 6 - wakeUpTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(wakeUpTime.weekday == 6){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              wakeUpTimeNotifyId,
              wakeUpTime,
              DateTimeComponents.dayOfWeekAndTime,
            );
          }
        }else if(data.repeatDays[i] == 'Sun'){
          print('Sun Notify');
          wakeUpTimeNotifyId = id + 14;
          if(wakeUpTime.weekday < 7){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              wakeUpTimeNotifyId,
              wakeUpTime.add(Duration(days: 7 - wakeUpTime.weekday)),
              DateTimeComponents.dayOfWeekAndTime,
            );
          }else if(wakeUpTime.weekday == 7){
            await notificationPlugin.repeatAtSpecificTimeNotification(
              wakeUpTimeNotifyId,
              wakeUpTime,
              DateTimeComponents.dayOfWeekAndTime,
            );
          }
        }
      }
      int count = await notificationPlugin.getPendingNotificationCount();
      print(count);
      return ;
    }
  }
}