import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubitController extends Cubit<int>{
  CounterCubitController(): super(0);

  void increment() => emit(state + 1);
}
