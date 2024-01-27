import 'package:booking_finland_washing_machine/backend/auth.dart';
import 'package:booking_finland_washing_machine/shared/constants.dart';
import 'package:booking_finland_washing_machine/shared/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {

  Function toogleView;

  Register(this.toogleView) {}

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _formKey = GlobalKey<FormState>();
  AuthService _authService = AuthService();

  bool loading = false; 

  // form values
  String? _currentName;
  String? _currentPassword;

  String error = "";

  @override
  Widget build(BuildContext context){
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        backgroundColor: background1,
        centerTitle: false,
        title: Text("Register", style: TextStyle(color: Colors.white)),
        actions: [
          ElevatedButton(
            style: buttonStyle.copyWith(backgroundColor: MaterialStatePropertyAll(Colors.white)),
            child: Text("Log In Instead", style: TextStyle(color: background2)),
            onPressed: () => widget.toogleView(),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                validator: (value) => value == null || value.isEmpty ? "Please enter a username" : null,
                decoration: textInputDecoration.copyWith(hintText: "Username"),
                onChanged: (value) => setState(() => _currentName = value),
              ),
              SizedBox(height: 8),
              TextFormField(
                validator: (value) => value == null || value.length < 6 ? "Please enter a minimum 6 character long password" : null,
                obscureText: true,
                decoration: textInputDecoration.copyWith(hintText: "Password"),
                onChanged: (value) => setState(() =>  _currentPassword = value),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: buttonStyle,
                child: Text("Register", style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  if(_formKey.currentState!.validate()){
                    setState(() {
                      loading = true;
                    });
                    User? user = await _authService.register(_currentName!, _currentPassword!);

                    if(user == null){
                      setState(() {
                        error = "Username already taken";
                        // for better UX : clear textformfield
                         
                        loading = false;
                      });
                    }
                  }
                },
              ),
              // error showing
              SizedBox(height: 10),
              Text(error, style: TextStyle(color: Colors.red))
            ]
          ),
        ),
      ),
    );
  }
}