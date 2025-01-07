import 'package:flutter/material.dart';

class DeleteEventPage extends StatelessWidget {
  final List<Map<String, String>> events;
  final Function(String) onEventDeleted;

  const DeleteEventPage({
    Key? key,
    required this.events,
    required this.onEventDeleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Delete Event")),
      body: Column(
        children: [
          Expanded(
            child: events.isEmpty
                ? Center(child: Text('No events available'))
                : ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Dismissible(
                  key: Key(event['title'] ?? '$index'),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Confirm Deletion'),
                        content: Text(
                            'Are you sure you want to delete "${event['title']}"?'
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      onEventDeleted(event['id']!);
                    }
                    return false; // Always return false to handle the dismissal manually
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: ListTile(
                    title: Text(event['title'] ?? 'Unnamed Event'),
                    subtitle: Text(
                        'Type: ${event['eventType'] ?? 'Not specified'}\n'
                            'Location: ${event['location'] ?? 'Not specified'}'
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Confirm Deletion'),
                            content: Text(
                                'Are you sure you want to delete "${event['title']}"?'
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true) {
                          onEventDeleted(event['id']!);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}