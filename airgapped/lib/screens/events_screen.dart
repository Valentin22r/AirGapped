import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/event_service.dart';
import '../widgets/event_card.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {

  List<Event> events = [];
  List<Event> filtered = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {

    events = await EventService.loadEvents();

    setState(() {
      filtered = events;
    });
  }

  void search(String value) {

    setState(() {

      filtered = events
          .where((e) =>
              e.title.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Events")),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(10),

            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search event...",
                prefixIcon: Icon(Icons.search),
              ),

              onChanged: search,
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,

              itemBuilder: (context, i) {
                return EventCard(event: filtered[i]);
              },
            ),
          )
        ],
      ),
    );
  }
}
