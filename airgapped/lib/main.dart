import 'package:flutter/material.dart';
import 'screens/events_screen.dart';
import 'screens/favorites_screen.dart';

void main() {
  runApp(const AirGappedApp());
}

class AirGappedApp extends StatelessWidget {
  const AirGappedApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Cybermois',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int index = 0;

  final pages = const [
    EventsScreen(),
    FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: pages[index],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,

        onTap: (i) => setState(() => index = i),

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: "Events",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Favorites",
          ),

        ],
      ),
    );
  }
}