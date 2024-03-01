import 'package:booking_finland_washing_machine/backend/calendar.dart';
import 'package:booking_finland_washing_machine/shared/constants.dart';
import 'package:booking_finland_washing_machine/shared/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AvailableBookingList extends StatefulWidget {

  final DateTime dateTime;

  final bool previousBooks;
  final bool nextBooks;

  AvailableBookingList(this.dateTime, this.previousBooks, this.nextBooks) {}

  @override
  State<AvailableBookingList> createState() => _AvailableBookingListState();
}

class _AvailableBookingListState extends State<AvailableBookingList> {
  @override
  Widget build(BuildContext context){

    bool isMobile = getDeviceType(MediaQuery.of(context).size) == DeviceScreenType.mobile;

    User? _currentUser = Provider.of<User?>(context);

    CalendarService _calendarService = CalendarService(dateFormat.format(widget.dateTime), _currentUser!.uid);

    // available slots
    Map<int, int> available = Provider.of<Map<int, int>>(context); 
    List<int> keys = available.keys.toList();


    return Container(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 42 : 50, vertical: isMobile ? 14 : 20),
        itemCount: 24,
        itemBuilder: (context, index) {
          //print("inside widget : $available");

          bool indexAvailable = keys.contains(index) && keys.contains(index + 1) && keys.contains(index - 1);
          // exceptions for 22-24 h and 00-02 h
          if(index == 22){
            indexAvailable = keys.contains(index)  && keys.contains(index - 1);
          }
          if(index == 0){
            indexAvailable = keys.contains(index)  && keys.contains(index + 1);
          }

          return (!widget.previousBooks && index < 8) || (!widget.nextBooks && index > 22) ? Container() : Padding(
            padding: EdgeInsets.only(bottom: isMobile ? 4 : 10),
            child: ElevatedButton(
              child: Text("${index}:00 - ${index + 2}:00", style: TextStyle(color: Colors.white, fontSize: isMobile ? 16 : 18)),
              onPressed: ()  {
                if (!indexAvailable)
                  return null;
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Book this slot ?", style: TextStyle(fontSize: 21),),
                      content: Text("${dateTimeToString(widget.dateTime)}\nFrom ${index}:00 to ${index + 2}:00"),
                      actions: [
                        TextButton(
                          child: Text("Cancel", style: TextStyle(color: background2)),
                          onPressed: () => Navigator.pop(context),
                        ),
                        TextButton(
                          child: Text("Yes", style: TextStyle(color: background2)),
                          onPressed: () async {
                            String? result = await _calendarService.bookTime(index);
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
          ) ;
        },
      ),
    );
  }
}