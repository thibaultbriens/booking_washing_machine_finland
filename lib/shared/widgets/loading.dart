import 'package:booking_finland_washing_machine/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
const Loading({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      child: SpinKitThreeBounce(
        color: background1
      ),
    );
  }
}