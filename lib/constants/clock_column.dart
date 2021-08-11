import 'dart:math';

import 'package:flutter/material.dart';

import '../config/size_configuration.dart';
import 'constant_colors.dart';

class ClockColumn extends StatelessWidget {
  String binaryInt;
  String title;
  Color color;
  int rows;
  List bits;

  ClockColumn({this.binaryInt, this.title, this.color, this.rows = 4}){
    bits = binaryInt.split('');
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ...[
          Container(
            child: Text(
              title,
              style: TextStyle(
                color: kPurpleColor,
                fontSize: getProportionateScreenWidth(26),
              ),
            ),
          ),
        ],
        ...bits.asMap().entries.map((e) {
          int idx = e.key;
          String val = e.value;

          bool isActive = val == '1';
          int binaryCellVal = pow(2, 3 - idx);

          return AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.ease,
            height: 40,
            width: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: isActive
                  ? color
                  : idx < 4 - rows ? Colors.white.withOpacity(0) : Colors.black38,
            ),
            margin: EdgeInsets.all(4),
            child: Center(
              child: isActive ? Text(
                binaryCellVal.toString(),
                style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  fontSize: getProportionateScreenWidth(20),
                  fontWeight: FontWeight.w700,
                ),
              ) : Container(),
            ),
          );
        }),
        ...[
          Text(
            int.parse(binaryInt, radix: 2).toString(),
            style: TextStyle(
              fontSize: getProportionateScreenWidth(40),
              color: color,
            ),
          ),
          Container(
            child: Text(
              binaryInt,
              style: TextStyle(
                fontSize: getProportionateScreenWidth(18),
                color: color,
              ),
            ),
          ),
        ]
      ],
    );
  }
}
