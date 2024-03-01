import 'package:booking_finland_washing_machine/backend/users.dart';
import 'package:booking_finland_washing_machine/shared/functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class CalendarService {

  final String dateUid;
  final String userUid;

  CalendarService(this.dateUid, this.userUid) {}

  // get collection reference
  final CollectionReference _cal = FirebaseFirestore.instance.collection("calendar");
  final CollectionReference _users = FirebaseFirestore.instance.collection("users");

  Future<List<dynamic>> getBookedList () async {
    try{

      DocumentSnapshot docSnap =  await _cal.doc(dateUid).get();

      if(docSnap.exists){
        // access the data from the snapshot
        Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;

        // get the booked list
        return data["booked"] ?? [];
      }
     } catch (e){
      print(e.toString());
      return [];
     }
     return [];
  }

  Future<List<dynamic>> getBookedByList () async {
    try{

      DocumentSnapshot docSnap =  await _cal.doc(dateUid).get();

      if(docSnap.exists){
        // access the data from the snapshot
        Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;

        // get the booked list
        return data["bookedBy"] ?? [];
      }
     } catch (e){
      print(e.toString());
      return [];
     }
     return [];
  }

  // check if we can add a booking
  Future<String?> checkTimeAvailabilty (int startingTime) async {
    try{
      // check that user doesn't already have a reservation for less that 7 days
      /*List<dynamic> userBookings = await Users(userUid).getBooked();
      DateTime current = dateStringtoDateTime(dateUid, hour: startingTime);
      print("current: " + current.toString());
      for(int i = 0; i < userBookings.length; i += 2){
        DateTime e = dateStringtoDateTime(userBookings[i], hour: userBookings[i + 1]);
        print("e: " + e.toString());

        
        if(e.difference(current).abs().inDays < 7)
          return "You have already used your weekly booking";
      }*/

      // get the booked list
      List<dynamic> booked = await getBookedList();
      
      if(booked.contains(startingTime) || booked.contains(startingTime)){
        return "Already booked";
      }
      return null;
  } catch(e) {
    print("in calendar.dart in checkAvailability" + e.toString());
    return "Error";
  }
  }

  Future<String?> bookTime (int startingTime) async {
    // check that time is available
    String? isAvailable = await checkTimeAvailabilty(startingTime);
    print("time is available : $isAvailable");

    if(isAvailable == null){
      try{
        List<dynamic> booked = await getBookedList();
        booked.add(startingTime);
        List<dynamic> bookedBy = await getBookedByList();
        bookedBy.add(userUid);
        Users(userUid).updateData(dateUid, startingTime);
        await _cal.doc(dateUid).set({
          "booked": booked,
          "bookedBy": bookedBy
        });
        return null;
      } catch(e){
        print("in calendar.dart in bookTime: " + e.toString());
        return "Error";
      }
    }
    return isAvailable;
  }


  List<int> _listFromSnap(DocumentSnapshot snapshot){
    try{
      List<dynamic> alreadyBooked = snapshot.get("booked");

      List<int> available = [];

      for(int i = 0; i < 24; i++){
        if(!alreadyBooked.contains(i))
          available.add(i);
      }

      return available;
    } catch(e){
      print("in calendar.dart in _listfromsnap: " + e.toString());
      return List.generate(24, (index) => index);
    }
  }

  Stream<List<int>> get availableBooking {
    return _cal.doc(dateUid).snapshots().map(_listFromSnap);
  }

  // delete a booking
  Future deleteBooking(int startingHour) async{
    List<dynamic> calendarBookings = await getBookedList();
    List<dynamic> calendarBookingsBy = await getBookedByList();
    
    // finding index to remove
    int indexToRemove = 0;
    for(int i = 0; i < calendarBookings.length ; i++){
      if(calendarBookings[i] == startingHour && calendarBookingsBy[i] == userUid){
        indexToRemove = i;
        break;
      }
    }
    calendarBookings.removeAt(indexToRemove);
    calendarBookingsBy.removeAt(indexToRemove);
    

    _cal.doc(dateUid).set({
      "booked" : calendarBookings,
      "bookedBy" : calendarBookingsBy
    });

    Users(userUid).deleteBooking(dateUid, startingHour);
  }
}