import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.only(left: 16, right: 16),
  labelStyle: TextStyle(
    color: Colors.white,
  ),
  errorStyle: TextStyle(fontSize: 15, color: Colors.yellow),
  hintStyle: TextStyle(fontSize: 15),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 2, color: Colors.white),
    borderRadius: BorderRadius.all(Radius.circular(20)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 2, color: Colors.white),
    borderRadius: BorderRadius.all(Radius.circular(20)),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 2, color: Colors.white),
    borderRadius: BorderRadius.all(Radius.circular(20)),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 2, color: Colors.white),
    borderRadius: BorderRadius.all(Radius.circular(20)),
  ),
);

const editInputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(horizontal: 16),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: Colors.white),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: Colors.white),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: Colors.white),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: Colors.white),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    hintStyle: TextStyle(color: Colors.black87));

changePasswordInputDecoration(text) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: Colors.white),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: Colors.white),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: Colors.white),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: Colors.white),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    hintText: text,
    hintStyle: TextStyle(
      color: Colors.grey[500],
      fontSize: 15,
    ),
  );
}


