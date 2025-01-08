import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/event_service.dart';
import 'pages/admin.dart';
import 'pages/profile.dart';
import 'pages/events_homepage.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
      },
      // home: HomePage(), // Changed from HomePage to LoginPage
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final EventService eventService = EventService();
  late Future<List<Map<String, String>>> events;

  @override
  void initState() {
    super.initState();
    events = fetchAndConvertEvents();
  }

  Future<List<Map<String, String>>> fetchAndConvertEvents() async {
    final fetchedEvents = await eventService.fetchEvents();
    return fetchedEvents.map<Map<String, String>>((event) {
      return event.map<String, String>((key, value) => MapEntry(key.toString(), value.toString()));
    }).toList();
  }

  void _handleEventDeleted(int id) async {
    try {
      await eventService.deleteEvent(id.toString());
      setState(() {
        events = fetchAndConvertEvents();
      });
    } catch (e) {
      // Handle error
      print('Failed to delete event: $e');
    }
  }

  void _handleEventCreated(Map<String, String> event) async {
    try {
      await eventService.createEvent(event);
      setState(() {
        events = fetchAndConvertEvents();
      });
    } catch (e) {
      // Handle error
      print('Failed to create event: $e');
    }
  }

  void _handleEventUpdated(String id, Map<String, String> event) async {
    try {
      await eventService.updateEvent(id, event);
      setState(() {
        events = fetchAndConvertEvents();
      });
    } catch (e) {
      // Handle error
      print('Failed to update event: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Events"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == "Profile") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ),
                );
              } else if (value == "Admin") {
                final password = await showDialog<String>(
                  context: context,
                  builder: (context) => PasswordDialog(),
                );
                if (password == "MSKU") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FutureBuilder<List<Map<String, String>>>(
                        future: events,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(child: Text('No events found.'));
                          } else {
                            return AdminPage(
                              events: snapshot.data!,
                              onEventAdded: (newEvent) {
                                _handleEventCreated(newEvent);
                                setState(() {
                                  events = fetchAndConvertEvents();
                                });
                              },
                              onEventDeleted: (id) {
                                _handleEventDeleted(int.parse(id));
                                setState(() {
                                  events = fetchAndConvertEvents();
                                });
                              },
                              onUpdateEvent: (id, updatedEvent) {
                                _handleEventUpdated(id, updatedEvent);
                                setState(() {
                                  events = fetchAndConvertEvents();
                                });
                              },
                            );
                          }
                        },
                      ),
                    ),
                  );
                } else if (password != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Incorrect password!")),
                  );
                }
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "Profile",
                child: Text("Profile"),
              ),
              PopupMenuItem(
                value: "Admin",
                child: Text("Admin"),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: events,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No events found.'));
          } else {
            return EventsHomePage(
              events: snapshot.data!,
              onEventDeleted: (id) => _handleEventDeleted(id),
            );
          }
        },
      ),
    );
  }

  Widget PasswordDialog() {
    return AlertDialog(
      title: Text('Enter Password'),
      content: TextField(
        obscureText: true,
        decoration: InputDecoration(labelText: 'Password'),
        onSubmitted: (value) {
          Navigator.of(context).pop(value);
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop('MSKU');
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}