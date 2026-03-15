import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/event.dart';

// Service to handle all local event storage operations
class EventService {

  // Get local file to store events
  static Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/events.json'); // events.json in app documents
  }

  // Load all events from local file
  static Future<List<Event>> loadEvents() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) {
        await file.writeAsString('[]'); // Create empty file if not exists
        return [];
      }
      final data = await file.readAsString();
      final List jsonResult = json.decode(data);
      return jsonResult.map((e) => Event.fromJson(e)).toList(); // Convert JSON to Event objects
    } catch (e) {
      print("Error loading events: $e");
      return [];
    }
  }

  // Save all events to local file
  static Future<void> saveEvents(List<Event> events) async {
    try {
      final file = await _getFile();
      await file.writeAsString(
        json.encode(events.map((e) => e.toJson()).toList()) // Convert Event objects to JSON
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

  // Delete an event by ID
  static Future<void> deleteEvent(String id) async {
    final events = await loadEvents();
    events.removeWhere((e) => e.id == id);
    await saveEvents(events);
  }

  // Update an existing event
  static Future<void> updateEvent(Event updatedEvent) async {
    final events = await loadEvents();
    final index = events.indexWhere((e) => e.id == updatedEvent.id);
    if (index != -1) {
      events[index] = updatedEvent;
      await saveEvents(events);
    }
  }
}