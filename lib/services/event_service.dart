import 'dart:convert';
import 'package:http/http.dart' as http;

class EventService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/events'; // Use 10.0.2.2 for Android emulator

  Future<List<dynamic>> fetchEvents() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<void> createEvent(Map<String, dynamic> event) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(event),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create event');
    }
  }

  Future<void> updateEvent(String id, Map<String, dynamic> event) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(event),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update event');
    }
  }

  Future<void> deleteEvent(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete event');
    }
  }
}