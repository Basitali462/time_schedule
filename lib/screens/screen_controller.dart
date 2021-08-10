import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:time_scheduler/config/ad_helper.dart';
import 'package:time_scheduler/config/size_config.dart';
import 'package:time_scheduler/config/size_configuration.dart';
import 'package:time_scheduler/constants/app_theme.dart';
import 'package:time_scheduler/screens/pages/alarm_page.dart';
import 'package:time_scheduler/screens/pages/bed_time.dart';
import 'package:time_scheduler/screens/pages/clock_page.dart';
import 'package:time_scheduler/screens/pages/stop_watch.dart';
import 'package:time_scheduler/services/notification_plugin.dart';
import 'package:time_scheduler/shared/bottom_nav_bar.dart';
import 'package:time_scheduler/shared/floating_button.dart';

class ScreenController extends StatefulWidget {
  @override
  _ScreenControllerState createState() => _ScreenControllerState();
}

class _ScreenControllerState extends State<ScreenController> {

  PageController pageController = PageController();
  int currentPage = 0;

  BannerAd bannerAd;
  bool isBannerAdReady = false;

  void onPageChanged(int page) async{
    //await notificationPlugin.repeatAtSpecificTimeNotification();
    /*await notificationPlugin.repeatedNotification();
    await notificationPlugin.cancelNotification();
    int count = await notificationPlugin.getPendingNotificationCount();
    print(count);*/
    //await notificationPlugin.cancelNotification();
    int count = await notificationPlugin.getPendingNotificationCount();
    //print(count);
    if(isBannerAdReady == false){
      //initBannerAd();
    }
    pageController.animateToPage(page, duration: Duration(milliseconds: 200), curve: Curves.linear);
    setState(() {
      currentPage = page;
    });
  }

  String setTitleText(){
    if(currentPage == 0){
      return 'world clock';
    }else if(currentPage == 1){
      return 'alarm';
    }else if(currentPage == 2){
      return 'bedtime';
    }else if(currentPage == 3){
      return 'stop watch';
    }
    return '';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //initBannerAd();
  }

  initBannerAd(){
    print('init banner');
    bannerAd = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdHelper.bannerAdUnitId,
      listener: AdListener(
        onAdLoaded: (_){
          print('Banner loaded');
          setState(() {
            isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err){
          print('Failed to load banner Ad: ${err.message}, ${ad}');
          isBannerAdReady = false;
          ad.dispose();
        },
      ),
      request: AdRequest(),);
    bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfiguration().init(context);
    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: isBannerAdReady
                ? bannerAd.size.height.toDouble()
                : 0,),
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                //leadingWidth: bannerAd.size.width.toDouble(),
                /*leading: isBannerAdReady ? Container(
                  width: bannerAd.size.width.toDouble(),
                  height: bannerAd.size.height.toDouble(),
                  child: AdWidget(ad: bannerAd,),
                ) : Container(),*/
                /*leadingWidth: 100,
                leading: Container(
                  margin: EdgeInsets.fromLTRB(30, 8, 30, 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(width: 1, color: Colors.grey.withOpacity(0.3)),
                  ),
                  child: Icon(
                    Icons.menu,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),*/
                title: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    setTitleText().toUpperCase(),
                    style: Theme.of(context).textTheme.appBarLabel,
                  ),
                ),
              ),
              body: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 2.4 * SizeConfig.heightMultiplier),
                    child: PageView(
                      controller: pageController,
                      physics: NeverScrollableScrollPhysics(),
                      //onPageChanged: onPageChanged,
                      children: [
                        Clock(),
                        Alarm(),
                        BedTime(),
                        StopWatchPage(),
                      ],
                    ),
                  ),
                  /*if(isBannerAdReady)
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: bannerAd.size.width.toDouble(),
                        height: bannerAd.size.height.toDouble(),
                        child: AdWidget(ad: bannerAd,),
                      ),
                    ),*/
                ],
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              floatingActionButton: FloatingButton(),
              bottomNavigationBar: BottomNavBar(currentPage, onPageChanged),
            ),
          ),
          /*if(isBannerAdReady)
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: bannerAd.size.width.toDouble(),
                height: bannerAd.size.height.toDouble(),
                child: AdWidget(ad: bannerAd,),
              ),
            ),*/
        ],
      ),
    );
  }
}
