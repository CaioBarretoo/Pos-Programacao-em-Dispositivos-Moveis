import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:state_managment_ex/config/routes.dart';
import 'package:state_managment_ex/cubit/counter_controller.dart';
import 'package:state_managment_ex/cubit/home.dart';
import 'package:state_managment_ex/getx/home.dart';
import 'package:state_managment_ex/provider/counter_controller.dart';
import 'package:state_managment_ex/provider/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: homeRoute,
      routes:{
        homeRoute: (context) => MyHomePage(),
        getxHomeRoute: (context) => HomeGetX(),
        providerHomeRoute: (context) => ChangeNotifierProvider(
          create: (context) =>  CounterProviderController(),
          child: HomeProvider(),
        ),
        cubitHomeRoute: (context) => BlocProvider(
          create: (context) => CounterCubitController(),
          child: HomeCubit(),
        )
      }
    );
  }
}

class MyHomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Choose your mode"),
      ),
      body: ListView(
      children: [
        ListTile(
          title: const Text("GetX"),
          trailing: const Icon(Icons.arrow_forward),
          onTap: (){
            Navigator.pushNamed(context, getxHomeRoute);
          },
        ),
          ListTile(
          title: const Text("Provider"),
          trailing: const Icon(Icons.arrow_forward),
          onTap: (){
            Navigator.pushNamed(context, providerHomeRoute);
          },
        ),
          ListTile(
            title: const Text("Cubit"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: (){
              Navigator.pushNamed(context, cubitHomeRoute);
            },
          ),
      ],
      )
    );
  }
}
