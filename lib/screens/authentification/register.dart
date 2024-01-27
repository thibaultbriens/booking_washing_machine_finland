import 'package:booking_finland_washing_machine/backend/auth.dart';
import 'package:booking_finland_washing_machine/shared/constants.dart';
import 'package:booking_finland_washing_machine/shared/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

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
  String? _currentFirstname;
  String? _currentLastname;

  String error = "";

  bool showPassword = false;
  bool showPasswordConfirmation = false;

  @override
  Widget build(BuildContext context){

    bool isMobile = getDeviceType(MediaQuery.of(context).size) == DeviceScreenType.mobile;

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
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: isMobile ? 30 : 50),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      validator: (value) => value == null || value.isEmpty ? "Please enter your firstname" : null,
                      decoration: textInputDecoration.copyWith(hintText: "Firstname"),
                      onChanged: (value) => setState(() =>  _currentFirstname = value),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      validator: (value) => value == null || value.isEmpty ? "Please enter your lastname" : null,
                      decoration: textInputDecoration.copyWith(hintText: "Lastname"),
                      onChanged: (value) => setState(() =>  _currentLastname = value),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              TextFormField(
                validator: (value) {
                  if(value == null || value.isEmpty)
                    return "Please enter a username";
                  if(value.toLowerCase() != value)
                    return "Enter a full lowercase username";
                  if(value.contains(' '))
                    return "Username should not contain spaces";
                  if(value.contains('@'))
                    return "Please enter a username, not an email";
                  return null;
                  },
                decoration: textInputDecoration.copyWith(hintText: "Username"),
                onChanged: (value) => setState(() => _currentName = value),
              ),
              SizedBox(height: 8),
              TextFormField(
                validator: (value) => value == null || value.isEmpty ? "Please enter a password" : null,
                obscureText: !showPassword,
                decoration: textInputDecoration.copyWith(
                  hintText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => showPassword = !showPassword),
                  ),
                  ),
                onChanged: (value) => setState(() =>  _currentPassword = value),
              ),
              SizedBox(height: 8),
              TextFormField(
                validator: (value) => value != _currentPassword ? "Both password don't match" : null,
                obscureText: showPasswordConfirmation,
                decoration: textInputDecoration.copyWith(
                  hintText: "Password Confirmation",
                  suffixIcon: IconButton(
                    icon: Icon(showPasswordConfirmation ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => showPasswordConfirmation = !showPasswordConfirmation),
                  ),
                  ),
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
                    User? user = await _authService.register(_currentFirstname!, _currentLastname!, _currentName!, _currentPassword!);

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