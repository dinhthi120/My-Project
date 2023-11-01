import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showFlushBar(context, message) {
  Flushbar(
    borderRadius: BorderRadius.circular(20),
    margin: const EdgeInsets.only(top: 18, left: 54, right: 54),
    padding: EdgeInsets.zero,
    flushbarStyle: FlushbarStyle.FLOATING,
    flushbarPosition: FlushbarPosition.TOP,
    animationDuration: const Duration(milliseconds: 1000),
    duration: const Duration(seconds: 1),
    messageText: Container(
      alignment: Alignment.center,
      height: 60,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  ).show(context);
}
