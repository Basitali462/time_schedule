import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper{

  Future<InitializationStatus> initGoogleMobileAds(){
    return MobileAds.instance.initialize();
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-9078213609015249/5880698599';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }
}