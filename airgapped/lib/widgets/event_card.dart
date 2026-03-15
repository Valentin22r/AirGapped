import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/event.dart';
import '../services/storage_service.dart';
import '../services/event_service.dart';
import '../screens/add_edit_event_screen.dart';

// Card widget to display an individual event
// Includes event info, favorite toggle, action buttons
class EventCard extends StatefulWidget {
  final Event event;
  const EventCard({super.key, required this.event});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool favorite = false; // favorite status

  static const platform = MethodChannel('airgapped/launcher'); // for opening links

  @override
  void initState() {
    super.initState();
    loadFavorite(); // load favorite status on init
  }

  // Load favorite status from local storage
  void loadFavorite() async {
    final favs = await StorageService.loadFavorites();
    if (!mounted) return;
    setState(() {
      favorite = favs.contains(widget.event.id);
    });
  }

  // Toggle favorite and save locally
  void toggleFavorite() async {
    final favs = await StorageService.loadFavorites();
    if (favs.contains(widget.event.id)) {
      favs.remove(widget.event.id);
    } else {
      favs.add(widget.event.id);
    }
    await StorageService.saveFavorites(favs);
    if (!mounted) return;
    setState(() {
      favorite = favs.contains(widget.event.id);
    });
  }

  // Open external link using platform channel
  Future<void> open(String url) async {
    try {
      await platform.invokeMethod("open", {"url": url});
    } catch (e) {
      debugPrint("Cannot open $url: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cannot open link: $url")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;

    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Row: logo + title + favorite button
            Row(
              children: [
                Image.asset('assets/logos/${event.logo}', width: 50),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    event.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(favorite ? Icons.star : Icons.star_border, color: Colors.amber),
                  onPressed: toggleFavorite,
                ),
              ],
            ),

            const SizedBox(height: 10),
            Text(event.description),
            const SizedBox(height: 10),
            Text("Date: ${event.date}"),
            Text("Location: ${event.location}"),
            const SizedBox(height: 10),

            // Row: action buttons (phone, email, website, map)
            Row(
              children: [
                if (event.phone.isNotEmpty)
                  IconButton(icon: const Icon(Icons.phone), onPressed: () => open("tel:${event.phone}")),
                if (event.email.isNotEmpty)
                  IconButton(icon: const Icon(Icons.email), onPressed: () => open("mailto:${event.email}")),
                if (event.website.isNotEmpty)
                  IconButton(icon: const Icon(Icons.language), onPressed: () => open(event.website)),
                if (event.location.isNotEmpty)
                  IconButton(icon: const Icon(Icons.map), onPressed: () => open("geo:0,0?q=${event.location}")),
              ],
            ),

            const SizedBox(height: 10),

            // Row: edit + delete buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                // Edit event
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddEditEventScreen(event: widget.event)),
                    );
                    if (updated == true && mounted) {
                      setState(() {}); // refresh card after editing
                    }
                  },
                ),

                // Delete event
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Delete Event"),
                        content: const Text("Are you sure you want to delete this event?"),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
                          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete")),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await EventService.deleteEvent(widget.event.id);
                      if (mounted) setState(() {}); // refresh card
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Event deleted")),
                      );
                    }
                  },
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
