import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_managment_ex/provider/counter_controller.dart';

class HomeProvider extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Provider Counter"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Consumer<CounterProviderController>
              (builder: (context, value, child) => Text(
                '${value.counter}',
                style: Theme.of(context).textTheme.headlineMedium,
              )
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Provider.of<CounterProviderController>(context, listen: false).increment();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
