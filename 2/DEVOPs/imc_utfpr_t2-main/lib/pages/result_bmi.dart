import 'package:flutter/material.dart';
import 'package:myapp/bmi_controller.dart';
import 'package:provider/provider.dart';

class ResultBMI extends StatelessWidget {
  const ResultBMI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Result BMI Calculator"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const Text("Your BMI result is:"),
            Text(
              Provider.of<BMIController>(context, listen: false).bmi
            ),
          ],
        ),
      ),
    );
  }
}