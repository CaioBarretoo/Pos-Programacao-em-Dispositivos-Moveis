import 'package:flutter/material.dart';
import 'package:ministerio_de_louvor/home/home.dart';
import 'package:ministerio_de_louvor/register/schedule/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ministerio_de_louvor/list/repertoire/home.dart';
import 'firebase_options.dart';
import 'list/schedule/home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt', 'BR')],
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1;

  static final List<Widget> _widgetOptions = <Widget>[
    HomeListSchedule(),
    HomePage(),
    HomeListRepertoire(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex), // Exibe a tela selecionada
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Escalas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ministério',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Repertório',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple, // Personalize a cor
        onTap: _onItemTapped,
      ),
    );
  }
}