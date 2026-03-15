import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import '../models/event.dart';

// Service to handle local storage for events and favorites
class StorageService {

  // -------- EVENTS FILE --------

  // Get local events.json file
  // If it doesn't exist, create it using the asset default events.json
  static Future<File> _getEventsFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/events.json');

    if (!await file.exists()) {
      final data = await rootBundle.loadString('assets/events.json'); // load default data
      await file.writeAsString(data);
    }

    return file;
  }

  // Load all events from local file
  static Future<List<Event>> loadEvents() async {
    try {
      final file = await _getEventsFile();
      final data = await file.readAsString();
      final List decoded = json.decode(data);

      // Convert each JSON object to Event
      return decoded.map((e) => Event.fromJson(e)).toList();
    } catch (e) {
      print("Error loading events: $e");
      return [];
    }
  }

  // Save all events to local file
  static Future<void> saveEvents(List<Event> events) async {
    try {
      final file = await _getEventsFile();
      // Convert each Event to JSON map before saving
      final jsonList = events.map((e) => e.toJson()).toList();
      await file.writeAsString(
        json.encode(jsonList),
        mode: FileMode.write,
        flush: true,
      );
    } catch (e) {
      print("Error saving events: $e");
    }
  }

  // Add a new event
  static Future<void> addEvent(Event event) async {
    final events = await loadEvents();
    events.add(event);
    await saveEvents(events);
  }

  // Update an existing event by index
  static Future<void> updateEvent(int index, Event updatedEvent) async {
    final events = await loadEvents();
    if (index >= 0 && index < events.length) {
      events[index] = updatedEvent;
      await saveEvents(events);
    }
  }

  // Delete an event by index
  static Future<void> deleteEvent(int index) async {
    final events = await loadEvents();
    if (index >= 0 && index < events.length) {
      events.removeAt(index);
      await saveEvents(events);
    }
  }

  // -------- FAVORITES FILE --------

  // Get local favorites.json file
  static Future<File> _getFavoritesFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/favorites.json');
  }

  // Load list of favorite event IDs
  static Future<List<String>> loadFavorites() async {
    try {
      final file = await _getFavoritesFile();
      if (!await file.exists()) return [];

      final data = await file.readAsString();
      final List decoded = json.decode(data);

      return decoded.map((e) => e.toString()).toList();
    } catch (e) {
      print("Error while reading favorites.json: $e");
      return [];
    }
  }

  // Save list of favorite event IDs
  static Future<void> saveFavorites(List<String> favs) async {
    try {
      final file = await _getFavoritesFile();

      final unique = favs.toSet().toList(); // remove duplicates

      await file.writeAsString(
        json.encode(unique),
        mode: FileMode.write,
        flush: true,
      );
    } catch (e) {
      print("Error while writing into favorites.json: $e");
    }
  }
}