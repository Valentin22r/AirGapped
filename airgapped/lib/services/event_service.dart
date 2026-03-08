import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/event.dart';

class EventService {

  static Future<List<Event>> loadEvents() async {

    final data = await rootBundle.loadString('assets/events.json');

    final List jsonResult = json.decode(data);

    return jsonResult.map((e) => Event.fromJson(e)).toList();
  }
}