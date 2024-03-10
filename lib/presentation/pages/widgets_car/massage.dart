import 'package:flutter/material.dart';

class CarMassage {
  void massage(BuildContext context) {
    const snackBar = SnackBar(
      duration: Duration(seconds: 5),
      content: Text('Такой ID уже используется'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
