import 'package:booking_finland_washing_machine/backend/auth.dart';
import 'package:booking_finland_washing_machine/backend/users.dart';
import 'package:booking_finland_washing_machine/screens/my_bookings/booking_list.dart';
import 'package:booking_finland_washing_machine/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyBookings extends StatelessWidget {

  DateTime dateTime;
  MyBookings(this.dateTime) {}

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context){

    User? _currentUser = Provider.of<User?>(context);
    Users _users = Users(_currentUser!.uid);;

    return StreamProvider<List<dynamic>>.value(
      initialData: [],
      value: _users.userBookings,
      child: Scaffold(
            appBar: AppBar(
              backgroundColor: background1,
              title: Text("My Bookings", style: TextStyle(color: Colors.white),),
              automaticallyImplyLeading: true,
              leading: IconButton(
                tooltip: "Go back",
                icon: Icon(Icons.arrow_back, size: 28, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)
                          )
                        ),
                    child: Text("Log Out", style: TextStyle(color: background2)),
                    onPressed: () async {
                      _authService.logOut();
                    },
                  ),
              ],
            ),
            body: BookingList(dateTime)
          ),
    );
      }
}