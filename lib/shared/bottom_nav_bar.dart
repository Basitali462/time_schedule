import 'package:flutter/material.dart';
import 'package:time_scheduler/config/size_config.dart';
import 'package:time_scheduler/config/size_configuration.dart';
import 'package:time_scheduler/constants/constant_colors.dart';
import 'package:time_scheduler/screens/screen_controller.dart';
import 'package:time_scheduler/services/notification_plugin.dart';

class BottomNavBar extends StatelessWidget {

  final int currentPage;
  final Function pageChange;

  BottomNavBar(this.currentPage, this.pageChange);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: IconButton(
              icon: Icon(
                Icons.access_time,
                color: currentPage == 0 ? kYellowColor : kGreyColor,
              ),
              iconSize: getProportionateScreenHeight(40),
              onPressed: (){
                pageChange(0);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 32, top: 8, bottom: 8),
            child: IconButton(
              icon: Icon(
                Icons.alarm,
                color: currentPage == 1 ? kYellowColor : kGreyColor,
              ),
              iconSize: getProportionateScreenHeight(40),
              onPressed: () {
                pageChange(1);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32, top: 8, bottom: 8),
            child: IconButton(
              icon: Icon(
                Icons.king_bed,
                color: currentPage == 2 ? kYellowColor : kGreyColor,
              ),
              iconSize: getProportionateScreenHeight(40),
              onPressed: (){
                pageChange(2);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: IconButton(
              icon: Icon(
                Icons.timer,
                color: currentPage == 3 ? kYellowColor : kGreyColor,
              ),
              iconSize: getProportionateScreenHeight(40),
              onPressed: (){
                pageChange(3);
              },
            ),
          ),
        ],
      ),
    );
  }
}
