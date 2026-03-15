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
  final dateController = TextEditingController();
  final locationController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final websiteController = TextEditingController();

  DateTime? selectedDate;

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
      dateController.text = e.date;
      locationController.text = e.location;
      phoneController.text = e.phone;
      emailController.text = e.email;
      websiteController.text = e.website;
      selectedDate = DateTime.tryParse(e.date);
    }
  }

  // Date picker
  void pickDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now.subtract(const Duration(days: 365 * 20)),
      lastDate: now.add(const Duration(days: 365 * 20)),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  // Check and save field
  void saveEvent() async {
    if (titleController.text.isEmpty || dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill at least title and date")),
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
      date: dateController.text,
      location: locationController.text,
      phone: phoneController.text,
      email: emailController.text,
      website: websiteController.text,
      logo: "event.jpeg", // default logo
      favory: widget.event?.favory ?? false, // keep favorite state
    );

    // Add or update event
    if (widget.event == null) {
      await EventService.addEvent(newEvent);
    } else {
      await EventService.updateEvent(newEvent);
    }

    if (!mounted)
      return;

    Navigator.pop(context, true);
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
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: "Date",
                prefixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: pickDate,
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
