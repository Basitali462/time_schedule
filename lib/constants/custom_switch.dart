/*
import 'package:flutter/material.dart';
import 'package:time_scheduler/config/size_config.dart';
import 'package:time_scheduler/constants/constant_colors.dart';
import 'package:time_scheduler/constants/inner_shadow.dart';

class CustomSwitch extends StatefulWidget {
  final bool toggleVal;
  final Function onChange;

  CustomSwitch({this.toggleVal, this.onChange});
  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> with SingleTickerProviderStateMixin {
  
  Animation switchAnimation;
  AnimationController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    switchAnimation = AlignmentTween(
      begin: widget.toggleVal ? Alignment.centerLeft : Alignment.centerRight,
      end: widget.toggleVal ? Alignment.centerRight : Alignment.centerLeft,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.linear));
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child){
        return GestureDetector(
          onTap: (){
            if(controller.isCompleted){
              controller.reverse();
            }else {
              controller.forward();
            }
            widget.toggleVal ? widget.onChange(false) : widget.onChange(true);
          },
          child: InnerShadow(
            blur: 2,
            color: kInnerShadow,
            offset: Offset(1, 1),
            child: Container(
              width: 18 * SizeConfig.widthMultiplier,
              height: 5.5 * SizeConfig.heightMultiplier,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6 * SizeConfig.heightMultiplier),
                color: kGreyColor,
                border: Border.all(width: 3, color: kDimOutline),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                      left: widget.toggleVal ? 8 * SizeConfig.widthMultiplier : 0,
                      child: InkWell(
                        onTap: switchToggle,
                        child: Container(
                          width: 6.3 * SizeConfig.widthMultiplier,
                          height: 3.7 * SizeConfig.heightMultiplier,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.toggleVal ? kYellowColor : kPurpleColor,
                          ),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                widget.toggleVal ? 'ON' : 'OFF',
                                style: TextStyle(
                                  color: widget.toggleVal ? kPurpleColor : kGreyColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },);
  }
}
*/
