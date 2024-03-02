import 'package:booking_finland_washing_machine/shared/constants.dart';
import 'package:flutter/material.dart';

String dateUidToString(String dateUid){
  return "${dateUid[0]}${dateUid[1]}/${dateUid[2]}${dateUid[3]}/${dateUid[4]}${dateUid[5]}${dateUid[6]}${dateUid[7]}";
}

String dateTimeToUid(DateTime dateTime){
  return "${dateTime.day.toString().padLeft(2, '0')}${dateTime.month.toString().padLeft(2, '0')}${dateTime.year}";
}

DateTime dateStringtoDateTime(String dateUid, {int hour = 0}){
  return DateTime(int.parse("${dateUid[4]}${dateUid[5]}${dateUid[6]}${dateUid[7]}"),
  int.parse("${dateUid[2]}${dateUid[3]}"), int.parse("${dateUid[0]}${dateUid[1]}"),
  hour);
}

String dateTimeToString(DateTime dateTime){
  return "${weekNames[dateTime.weekday - 1]} ${dateTime.day} ${monthNames[dateTime.month - 1]}, ${dateTime.year}";
}

String dateTimeToStringWeek(DateTime dateTimeInitial){
  DateTime dateTime = dateTimeInitial;
  while(dateTime.weekday != 1){
    dateTime = dateTime.subtract(Duration(days: 1));
  }
  String firstPart = "${dateTime.day} ${monthNames[dateTime.month - 1]}, ${dateTime.year}"; 

  while(dateTime.weekday != 7){
    dateTime = dateTime.add(Duration(days: 1));
  }
  String secondPart = "${dateTime.day} ${monthNames[dateTime.month - 1]}, ${dateTime.year}";

  return firstPart + " - " + secondPart;
}

bool dateTimeEqual(DateTime dt1, DateTime dt2){
  return dt1.day == dt2.day && dt1.month == dt2.month && dt1.year == dt2.year;
}