import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_scheduler/config/size_config.dart';
import 'package:time_scheduler/config/size_configuration.dart';
import 'package:time_scheduler/constants/constant_colors.dart';
import 'package:time_scheduler/constants/static_var.dart';
import 'package:time_scheduler/screens/pages/alarm_days.dart';
import 'package:time_scheduler/screens/pages/set_alarm.dart';
import 'package:time_scheduler/services/database.dart';
import 'package:time_scheduler/services/notification_plugin.dart';

class FloatingButton extends StatefulWidget {
  @override
  _FloatingButtonState createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton> {

  PageController _pageController = PageController();
  int currentPage = 0;

  void onPageChanged(int page){
    print(page);
    _pageController.animateToPage(page, duration: Duration(milliseconds: 200), curve: Curves.linear);
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showCupertinoModalPopup(
          context: context,
          builder: (_){
          return Dismissible(
            direction: DismissDirection.down,
            key: UniqueKey(),
            onDismissed: (_) => Navigator.of(context).pop(),
            child: PageView(
              controller: _pageController,
              onPageChanged: onPageChanged,
              physics: NeverScrollableScrollPhysics(),
              children: [
                SetAlarm(pageChange: onPageChanged,),
                AlarmDays(pageChange: onPageChanged,),
              ],
            ),
          );
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: getProportionateScreenHeight(16),
          horizontal: getProportionateScreenWidth(16),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(getProportionateScreenHeight(40)),
          gradient: LinearGradient(
            colors: [kGreyColor, kRedColor],
            begin: Alignment(-1.7, -1.7),
            end: Alignment(1.0, 1.0),
          ),
          boxShadow: [
            BoxShadow(
              color: kRedRadiusColor,
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(-0, 0),
            ),
            BoxShadow(
              color: kRedRadiusColor,
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: getProportionateScreenHeight(40),
        ),
        /*child: FloatingActionButton(
          //backgroundColor: kRedColor,
          onPressed: (){},
          child: Icon(Icons.add),
        ),*/
      ),
    );
  }
}
