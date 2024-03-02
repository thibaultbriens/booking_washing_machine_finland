import 'package:booking_finland_washing_machine/backend/calendar.dart';
import 'package:booking_finland_washing_machine/shared/constants.dart';
import 'package:booking_finland_washing_machine/shared/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingList extends StatelessWidget {

  DateTime dateTime;
  BookingList(this.dateTime) {}

  @override
  Widget build(BuildContext context){

    User? _currentUser = Provider.of<User?>(context);
    List<dynamic> _userBookings = Provider.of<List<dynamic>>(context);
    
    return ListView.builder(
              itemCount: (_userBookings.length / 2).toInt(),
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: ListTile(
                    title: Text(dateUidToString(_userBookings[index * 2])), // the Date
                    subtitle: Text("${_userBookings[index * 2 + 1]}:00 - ${_userBookings[index * 2 + 1] + 2}:00"),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: ()  {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Delete this slot ?", style: TextStyle(fontSize: 21),),
                              actions: [
                                TextButton(
                                  child: Text("Cancel", style: TextStyle(color: background2)),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                TextButton(
                                  child: Text("Yes", style: TextStyle(color: background2)),
                                  onPressed: () async {
                                    CalendarService(_userBookings[index * 2], _currentUser!.uid).deleteBooking(_userBookings[index * 2 + 1]);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          }
                        );
                      },
                      ),
                  ),
                );
              },
            );
  }
}