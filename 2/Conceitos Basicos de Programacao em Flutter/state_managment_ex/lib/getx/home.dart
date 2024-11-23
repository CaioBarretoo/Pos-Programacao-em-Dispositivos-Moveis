import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:state_managment_ex/getx/counter_controller.dart';

class HomeGetX extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final controller = CounterGetXController();

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("GetX Counter"),
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Obx(() => Text(
              '${controller.counter}',
              style: Theme.of(context).textTheme.headlineMedium,
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          controller.increment();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
