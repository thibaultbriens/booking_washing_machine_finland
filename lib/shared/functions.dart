import 'package:flutter/material.dart';

String dateUidToString(String dateUid){
  return "${dateUid[0]}${dateUid[1]}/${dateUid[2]}${dateUid[3]}/${dateUid[4]}${dateUid[5]}${dateUid[6]}${dateUid[7]}";
}

String dateTimeToString(DateTime dateTime){
  List<String> weekNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return "${weekNames[dateTime.weekday - 1]} ${dateTime.day} ${monthNames[dateTime.month]}, ${dateTime.year}";
}