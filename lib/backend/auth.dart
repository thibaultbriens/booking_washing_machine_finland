import 'package:booking_finland_washing_machine/backend/calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  Future logIn(String name, String password) async {

    try {

      UserCredential result = await _auth.signInWithEmailAndPassword(email: name + "@no.com", password: password);
      return result.user;

    } catch (e) {
      print(e.toString());
      return null;
    }

  }

  Future register(String username, String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: username + "@no.com", password: password);

      return result.user;
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  Future logOut() async {

    try {
      return _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }

  }
}