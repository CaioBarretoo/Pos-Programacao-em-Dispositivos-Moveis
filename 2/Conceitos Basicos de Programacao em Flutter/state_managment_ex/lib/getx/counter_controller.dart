import 'package:get/get.dart';

class CounterGetXController extends GetxController {
  final _counter = 0.obs;

  void increment(){
    _counter.value++;
  }

  int get counter => _counter.value;
}