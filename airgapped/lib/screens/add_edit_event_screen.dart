import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/event_service.dart';

// Screen to create or edit an event
// Can create new events or edit existing ones
class AddEditEventScreen extends StatefulWidget {
  final Event? event;
  const AddEditEventScreen({super.key, this.event});

  @override
  State<AddEditEventScreen> createState() => _AddEditEventScreenState();
}

class _AddEditEventScreenState extends State<AddEditEventScreen> {
  // Controllers for form fields
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final websiteController = TextEditingController();

  // Controllers for start/end date fields
  final startController = TextEditingController();
  final endController = TextEditingController();

  // Start and end date/time for the event
  DateTime? startDateTime;
  DateTime? endDateTime;

  // Regex patterns to validate email and phone
  final RegExp emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
  final RegExp phoneRegex = RegExp(r'^\+?\d{7,15}$');

  @override
  void initState() {
    super.initState();
    // Pre-fill form fields for existing event
    if (widget.event != null) {
      final e = widget.event!;
      titleController.text = e.title;
      descriptionController.text = e.description;
      locationController.text = e.location;
      phoneController.text = e.phone;
      emailController.text = e.email;
      websiteController.text = e.website;
      startDateTime = e.startDateTime;
      endDateTime = e.endDateTime;
      startController.text = formatDateTime(startDateTime);
      endController.text = formatDateTime(endDateTime);
    }
  }

  // Date & time picker helper
  Future<DateTime?> pickDateTime(DateTime? initialDate) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 20)),
    );
    if (date == null) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: initialDate != null
          ? TimeOfDay(hour: initialDate.hour, minute: initialDate.minute)
          : const TimeOfDay(hour: 9, minute: 0),
    );
    if (time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  // Pick start date & time
  void pickStartDateTime() async {
    final picked = await pickDateTime(startDateTime);
    if (picked != null) {
      setState(() {
        startDateTime = picked;
        startController.text = formatDateTime(startDateTime);

        // If end date is null or before start, initialize end = start + 1h
        if (endDateTime == null || endDateTime!.isBefore(startDateTime!)) {
          endDateTime = startDateTime!.add(const Duration(hours: 1));
          endController.text = formatDateTime(endDateTime);
        }
      });
    }
  }

  // Pick end date & time
  void pickEndDateTime() async {
    final picked = await pickDateTime(endDateTime);
    if (picked != null) {
      setState(() {
        // Ensure end is always after start
        if (startDateTime != null && picked.isBefore(startDateTime!)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("End date/time cannot be before start date/time")),
          );
          return;
        }
        endDateTime = picked;
        endController.text = formatDateTime(endDateTime);
      });
    }
  }

  // Check and save event
  void saveEvent() async {
    // Validate required fields
    if (titleController.text.isEmpty || startDateTime == null || endDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill title, start and end date/time")),
      );
      return;
    }

    // Validate email
    if (emailController.text.isNotEmpty && !emailRegex.hasMatch(emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid email format")),
      );
      return;
    }

    // Validate phone number
    if (phoneController.text.isNotEmpty && !phoneRegex.hasMatch(phoneController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid phone number")),
      );
      return;
    }

    // Create a new Event
    final newEvent = Event(
      id: widget.event?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: titleController.text,
      description: descriptionController.text,
      location: locationController.text,
      phone: phoneController.text,
      email: emailController.text,
      website: websiteController.text,
      logo: "event.jpeg", // default logo
      favory: widget.event?.favory ?? false, // keep favorite state
      startDateTime: startDateTime!,
      endDateTime: endDateTime!,
    );

    // Add or update event
    if (widget.event == null) {
      await EventService.addEvent(newEvent);
    } else {
      await EventService.updateEvent(newEvent);
    }

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  // Helper to format DateTime for display
  String formatDateTime(DateTime? dt) {
    if (dt == null) return '';
    return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} "
           "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar title changes if create or edit
      appBar: AppBar(title: Text(widget.event == null ? "Create Event" : "Edit Event")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Form fields
            TextField(controller: titleController, decoration: const InputDecoration(labelText: "Title")),
            TextField(controller: descriptionController, decoration: const InputDecoration(labelText: "Description")),

            // Start Date & Time
            TextField(
              controller: startController,
              readOnly: true,
              onTap: pickStartDateTime,
              decoration: const InputDecoration(
                labelText: "Start Date & Time",
                prefixIcon: Icon(Icons.calendar_today),
              ),
            ),

            // End Date & Time
            TextField(
              controller: endController,
              readOnly: true,
              onTap: pickEndDateTime,
              decoration: const InputDecoration(
                labelText: "End Date & Time",
                prefixIcon: Icon(Icons.calendar_today),
              ),
            ),

            TextField(controller: locationController, decoration: const InputDecoration(labelText: "Location")),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Phone", hintText: "+33123456789"),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email", hintText: "example@mail.com"),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(controller: websiteController, decoration: const InputDecoration(labelText: "Website")),
            const SizedBox(height: 20),

            // Button Save Event
            ElevatedButton(
              onPressed: saveEvent,
              child: Text(widget.event == null ? "Create Event" : "Save Event"),
            ),
          ],
        ),
      ),
    );
  }
}