import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/event.dart';
import '../services/storage_service.dart';

class EventCard extends StatefulWidget {

  final Event event;

  const EventCard({super.key, required this.event});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {

  bool favorite = false;

  static const platform = MethodChannel('airgapped/launcher');

  @override
  void initState() {
    super.initState();
    loadFavorite();
  }

  void loadFavorite() async {

    final favs = await StorageService.loadFavorites();

    if (!mounted) return;

    setState(() {
      favorite = favs.contains(widget.event.id);
    });
  }

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

  Future<void> open(String url) async {

    try {
      await platform.invokeMethod("open", {"url": url});
    } catch (e) {
      debugPrint("Cannot open $url");
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

            Row(
              children: [

                Image.asset(
                  'assets/logos/${event.logo}',
                  width: 50,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                IconButton(
                  icon: Icon(
                    favorite ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: toggleFavorite,
                )
              ],
            ),

            const SizedBox(height: 10),

            Text(event.description),

            const SizedBox(height: 10),

            Text("Date: ${event.date}"),
            Text("Location: ${event.location}"),

            const SizedBox(height: 10),

            Row(
              children: [

                if (event.phone.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.phone),
                    onPressed: () => open("tel:${event.phone}"),
                  ),

                if (event.email.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.email),
                    onPressed: () => open("mailto:${event.email}"),
                  ),

                if (event.website.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.language),
                    onPressed: () => open(event.website),
                  ),

                if (event.location.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.map),
                    onPressed: () => open(
                      "geo:0,0?q=${event.location}"
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}