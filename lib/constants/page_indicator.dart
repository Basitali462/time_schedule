import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'constant_colors.dart';

class PageIndicator extends StatelessWidget {
  final int activeIndex;

  PageIndicator({this.activeIndex});
  @override
  Widget build(BuildContext context) {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: 2,
      effect: JumpingDotEffect(
        activeDotColor: kYellowColor,
      ),
    );
  }
}
