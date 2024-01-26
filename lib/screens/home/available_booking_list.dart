import 'package:booking_finland_washing_machine/backend/calendar.dart';
import 'package:booking_finland_washing_machine/shared/constants.dart';
import 'package:booking_finland_washing_machine/shared/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AvailableBookingList extends StatefulWidget {

  DateTime dateTime;

  AvailableBookingList(this.dateTime) {}

  @override
  State<AvailableBookingList> createState() => _AvailableBookingListState();
}

class _AvailableBookingListState extends State<AvailableBookingList> {
  @override
  Widget build(BuildContext context){

    bool isMobile = getDeviceType(MediaQuery.of(context).size) == DeviceScreenType.mobile;

    User? _currentUser = Provider.of<User?>(context);

    CalendarService _calendarService = CalendarService(dateFormat.format(widget.dateTime), _currentUser!.uid);

    Map<int, int> available = Provider.of<Map<int, int>>(context);
    List<int> keys = available.keys.toList();

    return Container(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 42 : 50, vertical: isMobile ? 14 : 20),
        itemCount: available.length,
        itemBuilder: (context, index) {
          //print("inside widget : $available");
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton(
              child: Text("${keys[index]}:00 - ${keys[index] + 2}:00", style: TextStyle(color: Colors.white, fontSize: 18)),
              onPressed: ()  {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Book this slot ?", style: TextStyle(fontSize: 21),),
                      content: Text("${dateTimeToString(widget.dateTime)}\nFrom ${keys[index]}:00 to ${keys[index] + 2}:00"),
                      actions: [
                        TextButton(
                          child: Text("Cancel", style: TextStyle(color: background2)),
                          onPressed: () => Navigator.pop(context),
                        ),
                        TextButton(
                          child: Text("Yes", style: TextStyle(color: background2)),
                          onPressed: () async {
                            _calendarService.bookTime(keys[index]);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  }
                );
              },
              style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)
                    )
                  ),
            ),
          );
        },
      ),
    );
  }
}