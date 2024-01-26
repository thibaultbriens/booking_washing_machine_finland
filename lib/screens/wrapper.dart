import 'package:booking_finland_washing_machine/screens/authentification/authentification.dart';
import 'package:booking_finland_washing_machine/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
const Wrapper({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){

    final user = Provider.of<User?>(context);

    return user == null ? Authentification() : Home();
  }
}