import 'package:booking_finland_washing_machine/backend/auth.dart';
import 'package:booking_finland_washing_machine/shared/constants.dart';
import 'package:booking_finland_washing_machine/shared/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

bool isValidEmail(String? email) {
  if(email == null || email.isEmpty)
    return false;
  // Define a regular expression pattern for a simple email validation
  RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');

  // Check if the provided email matches the pattern
  return emailRegex.hasMatch(email);
}

class ResetPassword extends StatefulWidget {

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  bool loading = false; 

  final _formKey = GlobalKey<FormState>();
  AuthService _authService = AuthService();

  String error = "";
  String? _currentEmail;

  @override
  Widget build(BuildContext context){

    bool isMobile = getDeviceType(MediaQuery.of(context).size) == DeviceScreenType.mobile;

    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        backgroundColor: background1,
        centerTitle: false,
        title: Text("Reset password", style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: isMobile ? 30 : 50),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*Text("Email that to which you will receive the reset form", style: TextStyle(fontSize: 16),),
              SizedBox(height: 10,),*/
              TextFormField(
                validator: (value) => !isValidEmail(value) ? "Please enter a valid email" : null,
                decoration: textInputDecoration.copyWith(hintText: "Email"),
                onChanged: (value) => setState(() => _currentEmail = value),
              ),
              SizedBox(height: 15),
              Center(
                child: ElevatedButton(
                  style: buttonStyle,
                  child: Text("Reset Password", style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      setState(() {
                        loading = true;
                      });
                      User? user = await _authService.resetPassword(_currentEmail!);
                
                      if(user == null){
                        setState(() {
                          error = "An error occurred";
                          // for better UX : clear textformfield
                           
                          loading = false;
                        });
                      }
                    }
                  },
                ),
              ),
              // error showing
              SizedBox(height: 10),
              Center(child: Text(error, style: TextStyle(color: Colors.red)))
            ],
          ),
        ),
      ),
    );
  }
}