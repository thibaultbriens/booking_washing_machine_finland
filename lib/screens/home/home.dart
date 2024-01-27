import 'package:booking_finland_washing_machine/backend/auth.dart';
import 'package:booking_finland_washing_machine/backend/calendar.dart';
import 'package:booking_finland_washing_machine/screens/home/available_booking_list.dart';
import 'package:booking_finland_washing_machine/screens/home/available_booking_list_v2.dart';
import 'package:booking_finland_washing_machine/screens/my_bookings/my_bookings.dart';
import 'package:booking_finland_washing_machine/shared/constants.dart';
import 'package:booking_finland_washing_machine/shared/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  // date handler
  DateTime dateTime = DateTime.now();
  // back date handler
  bool backArrow = false;

  // to manage the view list
  bool previousBooks = false;
  bool nextBooks = false;
  String previousText = "See more";
  String nextText = "See more";
  var previousIcon = Icons.arrow_upward_rounded;
  var nextIcon = Icons.arrow_downward_rounded;
  void tooglePreviousOrNext(bool previous){ // if previous is true we are toogling previous
    if(previous){
      previousBooks = !previousBooks;
      previousText = previousBooks ? "See less" : "See more";
      previousIcon = previousBooks ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded;
    }
    else{
      nextBooks = !nextBooks;
      nextText = nextBooks ? "See less" : "See more";
      nextIcon = nextBooks ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {

    bool isMobile = getDeviceType(MediaQuery.of(context).size) == DeviceScreenType.mobile;

    final User? _currentUser = Provider.of<User?>(context);
    final AuthService _authSerivce = AuthService();
    final CalendarService _calendarService = CalendarService(dateFormat.format(dateTime), _currentUser!.uid);

    return StreamProvider<Map<int, int>>.value(
      initialData: {},
      value: _calendarService.availableBooking,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: background1,
          title: Text("Book a slot", style: TextStyle(color: Colors.white)),
          actions: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)
                    )
                  ),
              icon: Icon(Icons.person, color: background2,),
              label: Text("My Bookings", style: TextStyle(color: background2)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyBookings(dateTime)));
              },
            ),
            SizedBox(width: 10,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)
                    )
                  ),
              child: Text("Log Out", style: TextStyle(color: background2)),
              onPressed: () async {
                _authSerivce.logOut();
              },
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(isMobile ? 42 : 50, 20, 0, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    dateTimeToString(dateTime),
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 20,
                    ),
                  ),
                  SizedBox(width: 15,),
                  // back date button
                  Container(
                    width: isMobile ? 38 : 40,
                    height: isMobile ? 25 : 30,
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          if(previousBooks) 
                            tooglePreviousOrNext(true);
                          if(nextBooks)
                            tooglePreviousOrNext(false);
                        });
                        if(dateTime.day == DateTime.now().day){
                          setState(() {
                            backArrow = false;
                          });
                        }
                        else{
                          if(dateTime.day == DateTime.now().day + 1){
                            setState(() {
                              backArrow = false;
                            dateTime = dateTime.subtract(Duration(days: 1));
                          });
                          }
                          else{
                            setState(() {
                            dateTime = dateTime.subtract(Duration(days: 1));
                          });
                          }
                        }
                      },
                      color: backArrow ? background1 : Colors.grey[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Adjust the border radius as needed
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.white,
                        size: isMobile ? 19 : 25,
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  // next date button
                  Container(
                    width: isMobile ? 38 : 40,
                    height: isMobile ? 25 : 30,
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          if(previousBooks) 
                            tooglePreviousOrNext(true);
                          if(nextBooks)
                            tooglePreviousOrNext(false);
                          backArrow = true;
                          dateTime = dateTime.add(Duration(days: 1));
                        });
                      },
                      color: background1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Adjust the border radius as needed
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: isMobile ? 19 : 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: isMobile ? 35 : 44),
              child: TextButton.icon(
                icon: Icon(previousIcon, color: Colors.blue,),
                label: Text(previousText, style: TextStyle(color: Colors.blue),),
                onPressed: () {
                  setState(() {
                    tooglePreviousOrNext(true);
                  });
                },
              ),
            ),
            Expanded(child: AvailableBookingListV2(dateTime, previousBooks, nextBooks)),
            /*Padding(
              padding: EdgeInsets.fromLTRB(isMobile ? 35 : 44, 0, 0, 10),
              child: TextButton.icon(
                icon: Icon(nextIcon, color: Colors.blue,),
                label: Text(nextText, style: TextStyle(color: Colors.blue),),
                onPressed: () {
                  setState(() {
                    tooglePreviousOrNext(false);
                  });
                },
              ),
            ),*/
          ],
        )
      ),
    );
  }
}