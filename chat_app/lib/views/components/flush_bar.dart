import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

void showFlushBar(context, message) {
  Flushbar(
    borderRadius: BorderRadius.circular(20),
    margin: const EdgeInsets.only(top: 12, left: 36, right: 36),
    padding: EdgeInsets.zero,
    flushbarStyle: FlushbarStyle.FLOATING,
    flushbarPosition: FlushbarPosition.TOP,
    animationDuration: const Duration(milliseconds: 1000),
    duration: const Duration(seconds: 2),
    messageText: Container(
      alignment: Alignment.center,
      height: 60,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: Colors.blue[600],
        borderRadius: const BorderRadius.all(
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
