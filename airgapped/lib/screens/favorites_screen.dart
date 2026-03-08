import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/event_service.dart';
import '../services/storage_service.dart';
import '../widgets/event_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {

  List<Event> favorites = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  void loadFavorites() async {

    final events = await EventService.loadEvents();
    final favIds = await StorageService.loadFavorites();

    setState(() {

      favorites = events
          .where((e) => favIds.contains(e.id))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),

      body: favorites.isEmpty
          ? const Center(child: Text("No favorites yet"))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, i) {

                return EventCard(event: favorites[i]);
              },
            ),
    );
  }
}