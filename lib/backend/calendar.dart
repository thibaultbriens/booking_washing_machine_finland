import 'package:booking_finland_washing_machine/backend/users.dart';
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
  Future<bool> checkTimeAvailabilty (int startingTime) async {
    try{
      // first, check that the current user doesn't already have a reservation for this date
      List<dynamic> userBookings = await Users(userUid).getBooked();
      if(userBookings.contains(dateUid)){
        for(int i = 0; i < userBookings.length - 1; i += 2){
          if(userBookings[i] == dateUid && userBookings[i + 1] == startingTime){
            print("User already have this booking");
            return false;
          }
        }
      }

      // get the booked list
      List<dynamic> booked = await getBookedList();
      
      int n = 0; // number of occurences at the same starting time
      int m1 = 0; // number of occurences 1 hour after (since it is 2 hours slots it is mandatory to chekc that)
      int m2 = 0; // number of occurences 1 hour before (since it is 2 hours slots it is mandatory to chekc that)
      for(dynamic el in booked){
        if(el == startingTime)
          n++;
        else if(el == startingTime + 1)
          m1++;
        else if(el == startingTime - 1)
          m2++;
      }
      
      if(n == 2 || m1 == 2 || m2 == 2)
        return false;
      else if(n == 0)
        return true;
      else if(m2 == 1 && m1 == 1)
        return false;
      return true;

    } catch(e){
      print(e.toString());
      return false;
    }
  }

  Future bookTime (int startingTime) async {
    // check that time is available
    bool isAvailable = await checkTimeAvailabilty(startingTime);
    print("time is available : $isAvailable");

    if(isAvailable){
      try{
        List<dynamic> booked = await getBookedList();
        booked.add(startingTime);
        List<dynamic> bookedBy = await getBookedByList();
        bookedBy.add(userUid);
        Users(userUid).updateData(dateUid, startingTime);
        return await _cal.doc(dateUid).set({
          "booked": booked,
          "bookedBy": bookedBy
        });
      } catch(e){
        print(e.toString());
        return null;
      }
    }
    return null;
  }


  Map<int, int> _listFromSnap(DocumentSnapshot snapshot){
    try{
      List<dynamic> alreadyBooked = snapshot.get("booked");
      List<dynamic> alreadyBookedBy = snapshot.get("bookedBy");

      // now create the list of the available slots
      Map<int, int> available = {};
      // load all the Pairs in available
      //there is 2 slot available for each starting time, to start
      for(int i = 0; i < 23; i++){ // i stop to 22 because either way we need to look at the other day
        available[i] = 2;
      }
      for(int booked in alreadyBooked){
        available[booked] = available[booked]! - 1;
        if(available[booked] == 0){
          available.remove(booked);
          if(booked - 1 >= 0)
            available.remove(booked - 1);
          if(booked + 1 <= 22)
            available.remove(booked + 1);
        }
      }
      // update map
      bool deleted = true;
      while(deleted){
        List<int> toRemove = [];
        List<int> keys = available.keys.toList(); // list of the keys of availables
        bool lastRemoved = false; // to check that we don't delete 2 slots
        deleted = false;
        for(int i = 1; i < keys.length - 1; i++){
          if(available[keys[i]] == 1 && available[keys[i - 1]] == 1 && available[keys[i + 1]] == 1 && !lastRemoved){
            toRemove.add(keys[i]);
            deleted = true;
            lastRemoved = true;
          }
          else{
            lastRemoved = false;
          }
        }
        for(int el in toRemove){
          available.remove(el);
        }
      }

      // finally, remove the ones that the user already has
      if(alreadyBookedBy.contains(userUid)){
        List<int> toRemove = []; 
        for(int i = 0; i < alreadyBooked.length; i++){
          if(alreadyBookedBy[i] == userUid){
            toRemove.add(alreadyBooked[i]);
          }
        }
        for(int el in toRemove){
          available.remove(el);
        }
      }


      return available;
    } catch(e){
      print(e.toString());
      return Map.fromIterable(List.generate(23, (index) => index), value: (_) => 2);
    }
  }

  Stream<Map<int, int>> get availableBooking {
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