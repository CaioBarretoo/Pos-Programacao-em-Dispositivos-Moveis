import 'package:flutter/widgets.dart';
import 'package:myapp/config.dart';

class BMIController extends ChangeNotifier {
  String _bmi = results[0];
  String get bmi => _bmi;

  void calculateBMI({required double weight, required double height}) {
    final bmi = weight / (height * height);

    print('passou aqui');

    if (bmi < 18.5) {
      _bmi = results[1];
    } else if (bmi < 24.9) {
      _bmi = results[2];
    } else if (bmi < 29.9) {
      _bmi = results[3];
    } else if (bmi < 34.9) {
      _bmi = results[4];
    } else {
      _bmi = results[5];
    }

    notifyListeners();
  }
}
