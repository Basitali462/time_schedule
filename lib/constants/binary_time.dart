import 'package:intl/intl.dart';

class BinaryTime{
  List<String> binaryInt;

  BinaryTime(){
    DateTime now = DateTime.now();
    String hhmmss = DateFormat('Hms').format(now).replaceAll(':', '');

    binaryInt = hhmmss
        .split('')
        .map((e) => int.parse(e).toRadixString(2).padLeft(4, '0'))
        .toList();
  }

  get hourTens => binaryInt[0];
  get hourOnes => binaryInt[1];
  get minuteTens => binaryInt[2];
  get minuteOnes => binaryInt[3];
  get secondsTens => binaryInt[4];
  get secondsOnes => binaryInt[5];
}