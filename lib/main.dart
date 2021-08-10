import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_scheduler/config/ad_helper.dart';
import 'package:time_scheduler/config/size_config.dart';
import 'package:time_scheduler/config/size_configuration.dart';
import 'package:time_scheduler/constants/app_theme.dart';
import 'package:time_scheduler/locator.dart';
import 'package:time_scheduler/models/crud_model.dart';
import 'package:time_scheduler/screens/screen_controller.dart';
import 'package:time_scheduler/services/notification_plugin.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  AdHelper().initGoogleMobileAds();
  await Firebase.initializeApp();
  final String deviceId = await _getId();
  print(deviceId);
  setupLocator(deviceId);
  notificationPlugin.setListenerForLowerVersion(onNotificationInLowerVersion);
  notificationPlugin.setOnNotificationClick(onNotificationClick);
  runApp(DevicePreview(
    enabled: false,
    builder: (context) => MyApp(),
  ));
}

Future<String> _getId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) { // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.androidId; // unique ID on Android
  }
}

onNotificationInLowerVersion(ReceivedNotification receivedNotification){

}

onNotificationClick(String payload){

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
        return OrientationBuilder(
          builder: (context, orientation){
            SizeConfig().init(constraints, orientation);
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => locator<CRUDModel>()),
              ],
              child: MaterialApp(
                title: 'Flutter Demo',
                debugShowCheckedModeBanner: false,
                theme: themeData(context),
                home: ScreenController(),
              ),
            );
          },
        );
      },
    );
  }
}
