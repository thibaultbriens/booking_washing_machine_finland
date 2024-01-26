import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

var dateFormat = DateFormat("ddMMyyyy");

// Colors
var background1 = Colors.blue[300];
var background2 = Colors.blue;

var buttonStyle = ElevatedButton.styleFrom(
                  backgroundColor: background1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)
                  )
                );

var textInputDecoration = InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: background2,
                      width: 0.6
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: background2,
                      width: 1.6  
                    )
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: background2,
                      width: 0.6
                    )
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: background2,
                      width: 1.6  
                    )
                  ),
                );