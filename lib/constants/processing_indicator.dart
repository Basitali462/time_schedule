import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProcessingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          color: Colors.transparent,
        ),
        Center(
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Color(0xFFE0E0E0),
            ),
            child: CupertinoActivityIndicator(
              radius: 30,
            ),
          ),
        ),
      ],
    );
  }
}
