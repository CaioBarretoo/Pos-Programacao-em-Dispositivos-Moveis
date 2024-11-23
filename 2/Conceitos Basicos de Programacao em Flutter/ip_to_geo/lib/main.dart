import 'package:flutter/material.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: homeRoute,
      routes: {
        homeRoute: (context) => const MyHomePage(),
        mapRoute: (context) => MapLocation()
      },
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
          // 1
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
      // 2
      body: Center(child: _getCurrentWidget()),
    );
  }
  Widget _getCurrentWidget() => switch (_connectivityStatus) {
        ConnectivityStatus.checking => const CircularProgressIndicator(),
        ConnectivityStatus.offline => const Offline(),
        ConnectivityStatus.online => Online(),
      };
}