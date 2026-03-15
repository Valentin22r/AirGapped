import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/event_service.dart';
import '../widgets/event_card.dart';
import 'add_edit_event_screen.dart';

// Main screen displaying all events
// Supports filtering, searching, creating, and editing events
class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

// Filter type for events
enum DateFilter { all, upcoming, past }

class _EventsScreenState extends State<EventsScreen> {
  List<Event> events = []; // All events
  List<Event> filtered = []; // Filtered events
  DateFilter dateFilter = DateFilter.all; // Current filter
  String searchTerm = ""; // Search query

  @override
  void initState() {
    super.initState();
    load(); // Load events on start
  }

  // Load events from local service
  void load() async {
    events = await EventService.loadEvents();
    applyFilters(); // Apply search & date filters
  }

  // Filter events based on search term and date filter
  void applyFilters() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    List<Event> temp = events.where((e) {
      final eDate = e.startDateTime;
      final eventDay = DateTime(eDate.year, eDate.month, eDate.day);

      // Search filter
      if (searchTerm.isNotEmpty &&
          !e.title.toLowerCase().contains(searchTerm.toLowerCase())) {
        return false;
      }

      // Date filter
      if (dateFilter == DateFilter.upcoming) {
        return !eventDay.isBefore(today);
      } else if (dateFilter == DateFilter.past) {
        return eventDay.isBefore(today);
      }

      return true;
    }).toList();

    // Sort events by startDateTime
    temp.sort((a, b) {
      final aDate = a.startDateTime;
      final bDate = b.startDateTime;

      if (dateFilter == DateFilter.upcoming) return aDate.compareTo(bDate);
      if (dateFilter == DateFilter.past) return bDate.compareTo(aDate);
      return aDate.compareTo(bDate);
    });

    setState(() {
      filtered = temp; // Update filtered list
    });
  }

  // Update search term and reapply filters
  void search(String value) {
    searchTerm = value;
    applyFilters();
  }

  // Open add/edit event screen
  // Reloads events automatically after saving
  void openAddEditEvent({Event? event}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditEventScreen(event: event)),
    );

    if (result == true) {
      load(); // Reload list after save
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with refresh button
      appBar: AppBar(
        title: const Text("Events"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Reload",
            onPressed: load, // Reload list manually
          ),
        ],
      ),
      body: Column(
        children: [
          // Search input
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
          // Date filter dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                DropdownButton<DateFilter>(
                  value: dateFilter,
                  items: const [
                    DropdownMenuItem(value: DateFilter.all, child: Text("Filter: All")),
                    DropdownMenuItem(value: DateFilter.upcoming, child: Text("Filter: Upcoming")),
                    DropdownMenuItem(value: DateFilter.past, child: Text("Filter: Past")),
                  ],
                  onChanged: (val) {
                    if (val == null) return;
                    setState(() {
                      dateFilter = val;
                      applyFilters(); // Reapply filters on change
                    });
                  },
                ),
              ],
            ),
          ),
          // List of events
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, i) => GestureDetector(
                onTap: () => openAddEditEvent(event: filtered[i]),
                child: EventCard(event: filtered[i]), // Display each event
              ),
            ),
          ),
        ],
      ),
      // Floating button to create a new event
      floatingActionButton: FloatingActionButton(
        onPressed: () => openAddEditEvent(),
        child: const Icon(Icons.add),
        tooltip: "Create Event",
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}