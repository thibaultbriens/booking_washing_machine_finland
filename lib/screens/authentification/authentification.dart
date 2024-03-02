import 'package:booking_finland_washing_machine/screens/authentification/login.dart';
import 'package:booking_finland_washing_machine/screens/authentification/register.dart';
import 'package:flutter/material.dart';

class Authentification extends StatefulWidget {

  @override
  State<Authentification> createState() => _AuthentificationState();
}

class _AuthentificationState extends State<Authentification> {
  bool viewLogIn = true;

  void toogleView(){
    setState(() => viewLogIn = !viewLogIn);
  }

  @override
  Widget build(BuildContext context){
    return viewLogIn ? Login(toogleView) : Register(toogleView);
  }
}