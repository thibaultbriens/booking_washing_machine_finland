import 'package:booking_finland_washing_machine/backend/calendar.dart';
import 'package:booking_finland_washing_machine/shared/constants.dart';
import 'package:booking_finland_washing_machine/shared/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AvailableBookingListDesktop extends StatelessWidget {

  final DateTime dateTime;

  final bool previousBooks;
  final bool nextBooks;

  AvailableBookingListDesktop(this.dateTime, this.previousBooks, this.nextBooks) {}

  @override
  Widget build(BuildContext context){

    bool isMobile = getDeviceType(MediaQuery.of(context).size) == DeviceScreenType.mobile;
    // ge the size of the screen
    Size screenSize = MediaQuery.of(context).size;

    User? _currentUser = Provider.of<User?>(context);


    // padding
    double horizontalPadding = isMobile ? 42 : 50;
    double insideHorPad = 8;

    DateTime beginningOfTheWeek = dateTime.subtract(Duration(days: dateTime.weekday - 1));


    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: isMobile ? 14 : 20),
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            7,
            (index1){
              // get current date
              DateTime currentDateTime = beginningOfTheWeek.add(Duration(days: index1));

              CalendarService calendarService = CalendarService(dateTimeToUid(currentDateTime), _currentUser!.uid);

              return StreamBuilder<List<int>>(
                stream: calendarService.availableBooking,
                initialData: [],
                builder: (context, snapshot) {
                  // get data from snapshot
                  List<int> available = snapshot.data!; 

                  return Column(
                    children: [
                      Text("${weekNames[currentDateTime.weekday - 1]}", style: TextStyle(fontSize: isMobile ? 14 : 17,),),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: insideHorPad, vertical: 5),
                        child: Column(
                          children: List.generate(
                            24,
                            (index) {

                              // building our availability condition 
                              bool indexAvailable = (available.contains(index) && available.contains(index + 1) && available.contains(index - 1));
                              // exceptions for 22-24 h and 00-02 h
                              if(index == 22){
                                indexAvailable = available.contains(index)  && available.contains(index - 1);
                              }
                              if(index == 0){
                                indexAvailable = available.contains(index)  && available.contains(index + 1);
                              }
                              // if the day is before the current day
                              if(currentDateTime.isBefore(DateTime.now()) && currentDateTime.difference(DateTime.now()).inDays != 0){
                                indexAvailable = false;
                              }
                              // if it is the current day and the hour is already passed
                              if(dateTimeEqual(currentDateTime, DateTime.now()) && index <= DateTime.now().hour){
                                indexAvailable = false;
                              }
                                      
                              return (!previousBooks && index < 8) || (!nextBooks && index > 22) ? Container() 
                              : Container(
                                width: (screenSize.width - 2 * horizontalPadding - 7 * insideHorPad * 2) / 7,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: isMobile ? 4 : 10),
                                  child: ElevatedButton(
                                    child: Text('${index.toString().padLeft(2, '0')}:00 - ${(index + 2).toString().padLeft(2, '0')}:00', style: TextStyle(color: Colors.white, fontSize: isMobile ? 16 : 18)),
                                    onPressed: !indexAvailable ? null :()  {
                                      if (!indexAvailable)
                                        return null;
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("Book this slot ?", style: TextStyle(fontSize: 21),),
                                            content: Text("${dateTimeToString(currentDateTime)}\nFrom ${index}:00 to ${index + 2}:00"),
                                            actions: [
                                              TextButton(
                                                child: Text("Cancel", style: TextStyle(color: background2)),
                                                onPressed: () => Navigator.pop(context),
                                              ),
                                              TextButton(
                                                child: Text("Yes", style: TextStyle(color: background2)),
                                                onPressed: () async {
                                                  String? result = await calendarService.bookTime(index);
                                                  if(result == null){
                                                    Navigator.pop(context);
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: Text("🎉", textAlign: TextAlign.center, style: TextStyle(fontSize: 40)),
                                                        content: Text("Successfully booked,\nSee all your bookings by clicking the top right corner", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500)),
                                                        /*actions: [
                                                          TextButton(
                                                            child: Text("Close", style: TextStyle(color: background2)),
                                                            onPressed: () => Navigator.pop(context),
                                                          ) 
                                                        ],*/
                                                        );
                                                      }
                                                    );
                                                  }
                                                  else{
                                                    Navigator.pop(context);
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: Text(result, textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
                                                        );
                                                      }
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          );
                                        }
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                          backgroundColor: indexAvailable ? Colors.blue[300] : Color.fromARGB(206, 205, 208, 209),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4)
                                          )
                                        ),
                                  ),
                                ),
                              ) ;
                            },
                          )
                        ),
                      ),
                    ],
                  );
                }
              );
            }
          )
        ),
      ),
    );
  }
}