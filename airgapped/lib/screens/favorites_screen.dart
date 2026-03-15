import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/event_service.dart';
import '../services/storage_service.dart';
import '../widgets/event_card.dart';

// Screen showing all favorite events
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Event> favorites = []; // List of favorite events

  @override
  void initState() {
    super.initState();
    loadFavorites(); // Load favorites on start
  }

  // Load favorite events from local storage
  void loadFavorites() async {
    final events = await EventService.loadEvents(); // Load all events
    final favIds = await StorageService.loadFavorites(); // Load saved favorite IDs

    setState(() {
      // Keep only events that are marked as favorites
      favorites = events.where((e) => favIds.contains(e.id)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),

      // Show message if no favorites, otherwise list them
      body: favorites.isEmpty
          ? const Center(child: Text("No favorites yet"))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, i) {
                return EventCard(event: favorites[i]); // Display each favorite
              },
            ),
    );
  }
}