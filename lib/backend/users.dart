import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Users {

  final String uid;

  Users (this.uid) {}

  CollectionReference _users = FirebaseFirestore.instance.collection("users");

  Future<List<dynamic>> getBooked () async {
    try{
      DocumentSnapshot docSnap =  await _users.doc(uid).get();

      if(docSnap.exists){
        // access the data from the snapshot
        Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;

        // get the booked list
        return data["bookings"] ?? [];
      }
     } catch (e){
      print(e.toString());
      return [];
     }
     return [];
  }

  // push new data to a user document
  Future updateData (String date, int hour) async{
    try{
      List<dynamic> currentBookings = await getBooked();
      currentBookings.add(date);
      currentBookings.add(hour);

      try{
        return await _users.doc(uid).update({
          "bookings" : currentBookings
        });
      } catch (e){
        return await _users.doc(uid).set({
          "bookings" : currentBookings
        });
      }
    } catch(e){
      print("in users.dart in updateData: " + e.toString());
      return null;
    }
  }

  List<dynamic> _stringListFromDocSnap (DocumentSnapshot snap) {
    try{
      return snap.get("bookings");
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Stream<List<dynamic>> get userBookings {
    return _users.doc(uid).snapshots().map(_stringListFromDocSnap);
  }

  Future deleteBooking(String dateUid, int startingHour) async {
    List<dynamic> currentBookings = await getBooked();
    List<dynamic> newBookings = [];

    for(int i = 0; i < currentBookings.length - 1; i += 2){
      if(currentBookings[i] == dateUid && currentBookings[i + 1] == startingHour)
        continue;
      newBookings.add(currentBookings[i]);
      newBookings.add(currentBookings[i + 1]);
    }

    _users.doc(uid).update({
      "bookings" : newBookings
    });
  }
}