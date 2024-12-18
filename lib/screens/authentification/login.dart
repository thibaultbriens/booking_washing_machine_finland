import 'package:booking_finland_washing_machine/backend/auth.dart';
import 'package:booking_finland_washing_machine/screens/authentification/reset_password.dart';
import 'package:booking_finland_washing_machine/shared/constants.dart';
import 'package:booking_finland_washing_machine/shared/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Login extends StatefulWidget {

  Function toogleView;

  Login(this.toogleView) {}

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();
  AuthService _authService = AuthService();

  bool loading = false; 

  // form values
  String? _currentName;
  String? _currentPassword;

  String error = "";

  bool showPassword = false;

  void _submitLogIn() async {
    if(_formKey.currentState!.validate()){
      setState(() {
        loading = true;
      });
      User? user = await _authService.logIn(_currentName!, _currentPassword!);

      if(user == null){
        setState(() {
          error = "Username or password incorrect, please try again";
          // for better UX : clear textformfield
            
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context){

    bool isMobile = getDeviceType(MediaQuery.of(context).size) == DeviceScreenType.mobile;

    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        backgroundColor: background1,
        centerTitle: false,
        title: Text("Log in", style: TextStyle(color: Colors.white)),
        actions: [
          ElevatedButton(
            style: buttonStyle.copyWith(backgroundColor: MaterialStatePropertyAll(Colors.white)),
            child: Text("Register Instead", style: TextStyle(color: background2)),
            onPressed: () => widget.toogleView(),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: isMobile ? 30 : 50),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                validator: (value) => value == null || value.isEmpty ? "Please enter a username" : null,
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
                onFieldSubmitted: (value) => _submitLogIn(),
              ),
              SizedBox(height: 5),
              TextButton(
                child: Text("Password forgotten", style: TextStyle(color: background2)),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPassword()));
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
                  splashFactory: NoSplash.splashFactory,
                ),
              ),
              SizedBox(height: 15),
              Center(
                child: ElevatedButton(
                  style: buttonStyle,
                  child: Text("Log In", style: TextStyle(color: Colors.white)),
                  onPressed: _submitLogIn,
                ),
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