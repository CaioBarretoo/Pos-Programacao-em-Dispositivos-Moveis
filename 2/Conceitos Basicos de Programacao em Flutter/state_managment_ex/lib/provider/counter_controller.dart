import 'package:flutter/material.dart';

class CounterProviderController extends ChangeNotifier {
  int _counter = 0;

  void increment(){
    _counter++;
    notifyListeners();
  }

  int get counter => _counter;
}