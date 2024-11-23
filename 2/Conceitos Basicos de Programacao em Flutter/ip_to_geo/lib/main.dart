import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ip_to_geo/bindings/main_binding.dart';
import 'package:ip_to_geo/map_location.dart';
import 'package:ip_to_geo/widgets/conn_state.dart';
import 'package:ip_to_geo/widgets/offline.dart';
import 'package:ip_to_geo/widgets/online.dart';

const homeRoute = "/home";
const mapRoute = "/map";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: homeRoute,
      getPages: [
        GetPage(
            name: homeRoute,
            page: () => const MyHomePage(),
            binding: MainBindings()),
        GetPage(
            name: mapRoute,
            page: () => MapLocation())
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  ConnectivityStatus _connectivityStatus = ConnectivityStatus.checking;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("IP -> Geo"),
        actions: [
          TextButton(
              onPressed: () {},
              child: ConnStatus(
                callback: (status) {
                  setState(() {
                    _connectivityStatus = status;
                  });
                },
              ))
        ],
      ),
      body: Center(child: _getCurrentWidget()),
    );
  }

  Widget _getCurrentWidget() => switch (_connectivityStatus) {
    ConnectivityStatus.checking => const CircularProgressIndicator(),
    ConnectivityStatus.offline => Offline(),
    ConnectivityStatus.online => Online(),
  };
}