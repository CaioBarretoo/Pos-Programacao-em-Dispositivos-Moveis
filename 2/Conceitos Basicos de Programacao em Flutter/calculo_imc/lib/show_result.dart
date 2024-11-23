import 'package:flutter/material.dart';

class ShowResult extends StatelessWidget {
  ShowResult({super.key});

  late String message;

  @override
  Widget build(BuildContext context) {
    final message = (ModalRoute.of(context)!.settings.arguments as Map<String, String>)['result'] ?? '';
    

    return Scaffold(

      appBar: AppBar(
        title: const Text("Resultado")
      ),
      body: Center(
        child: Text(message)
        )
    );
  }
}