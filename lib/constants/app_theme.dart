import 'package:flutter/material.dart';
import 'package:time_scheduler/config/size_config.dart';
import 'package:time_scheduler/config/size_configuration.dart';

import 'constant_colors.dart';

extension CustomTextStyle on TextTheme{
  TextStyle get appBarLabel{
    return TextStyle(
      fontSize: getProportionateScreenWidth(26),
      color: kPurpleColor,
      fontWeight: FontWeight.bold,
    );
  }
  
  TextStyle get bodyText{
    return TextStyle(
      fontSize: 2.3 * SizeConfig.textMultiplier,
      color: kPurpleColor,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle get clockText{
    return TextStyle(
      fontSize: getProportionateScreenWidth(50),
      color: kPurpleColor,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle get alarmMed{
    return TextStyle(
      fontSize: 15.5 * SizeConfig.textMultiplier,
      fontWeight: FontWeight.bold,
      color: kInnerShadow,
    );
  }

  TextStyle get alarmDays{
    return TextStyle(
      fontSize: 3 * SizeConfig.textMultiplier,
      fontWeight: FontWeight.bold,
      color: kPurpleColor,
    );
  }

  TextStyle get bedTimeHr{
    return TextStyle(
      fontSize: 9.5 * SizeConfig.textMultiplier,
      color: kShadowColor,
      fontWeight: FontWeight.w900,
    );
  }

  TextStyle get bedTime{
    return TextStyle(
      fontSize: 9.5 * SizeConfig.textMultiplier,
      fontWeight: FontWeight.w900,
      foreground: Paint()..shader =
      LinearGradient(
        colors: [kGreyColor, kYellowColor],
        begin: Alignment(0, 0),
        end: Alignment(3, 3),
      ).createShader(Rect.fromLTWH(0, 0, 200, 70),),
    );
  }

  TextStyle get stopWatchBody{
    return TextStyle(
      fontSize: 2.6 * SizeConfig.textMultiplier,
      fontWeight: FontWeight.bold,
      color: kPurpleColor,
    );
  }

  TextStyle get lapTime{
    return TextStyle(
      fontSize: 1.7 * SizeConfig.textMultiplier,
      fontWeight: FontWeight.bold,
      color: kPurpleColor,
    );
  }
}

ThemeData themeData(BuildContext context){
  return ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: kGreyColor,
      elevation: 0,
    ),
    primaryColor: kPurpleColor,
    scaffoldBackgroundColor: kGreyColor,
    iconTheme: IconThemeData(
      color: Colors.grey,
    ),
    textTheme: TextTheme(),
    bottomAppBarTheme: BottomAppBarTheme(
      color: kPurpleColor,
      shape: CircularNotchedRectangle(),
    ),
  );
}