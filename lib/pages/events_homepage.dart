import 'package:flutter/material.dart';

class EventsHomePage extends StatefulWidget {
  final List<Map<String, String>> events;
  final Function(int)? onEventDeleted;

  EventsHomePage({
    Key? key,
    required this.events,
    this.onEventDeleted,
  }) : super(key: key);

  @override
  EventsHomePageState createState() => EventsHomePageState();
}

class EventsHomePageState extends State<EventsHomePage> {
  Map<int, int> ratings = {};
  Map<int, bool?> attendance = {};
  String? selectedEventType;

  void cleanupEventData(int deletedIndex) {
    setState(() {
      ratings.remove(deletedIndex);
      attendance.remove(deletedIndex);

      for (int i = deletedIndex; i < widget.events.length; i++) {
        ratings[i] = ratings[i + 1] ?? 0;
        attendance[i] = attendance[i + 1];
      }

      ratings.remove(widget.events.length);
      attendance.remove(widget.events.length);
    });
  }

  List<Map<String, String>> getFilteredEvents() {
    if (selectedEventType == null) return widget.events;
    return widget.events
        .where((event) => event['event_type'] == selectedEventType)
        .toList();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          Icons.photo_camera,
          size: 48,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildEventImage(String? photoUrl) {
    return Container(
      height: 200,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: photoUrl?.isNotEmpty == true
            ? Image.network(
          photoUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(child: CircularProgressIndicator());
          },
        )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildRatingBar(int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (starIndex) {
        return IconButton(
          icon: Icon(
            Icons.star,
            color: (ratings[index] ?? 0) > starIndex
                ? Colors.amber
                : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              ratings[index] = starIndex + 1;
            });
          },
        );
      }),
    );
  }

  Widget _buildEventDetails(Map<String, String> event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event['title'] ?? '',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 4),
        Text(
          "Type: ${event['event_type'] ?? 'Not specified'}",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        Text(event['description'] ?? ''),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(event['location'] ?? ''),
            Text(event['author'] ?? ''),
          ],
        ),
      ],
    );
  }

  Widget _buildAttendanceButtons(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          icon: Icon(Icons.check_circle),
          label: Text('I will attend'),
          style: ElevatedButton.styleFrom(
            backgroundColor: attendance[index] == true
                ? Colors.green
                : null,
          ),
          onPressed: () {
            setState(() {
              attendance[index] = true;
            });
          },
        ),
        ElevatedButton.icon(
          icon: Icon(Icons.cancel),
          label: Text('I cannot attend'),
          style: ElevatedButton.styleFrom(
            backgroundColor: attendance[index] == false
                ? Colors.red
                : null,
          ),
          onPressed: () {
            setState(() {
              attendance[index] = false;
            });
          },
        ),
      ],
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Filter by Event Type",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: Text("All Events"),
                selected: selectedEventType == null,
                onSelected: (bool selected) {
                  setState(() {
                    selectedEventType = null;
                  });
                },
              ),
              FilterChip(
                label: Text("Educational"),
                selected: selectedEventType == "Educational",
                onSelected: (bool selected) {
                  setState(() {
                    selectedEventType = selected ? "Educational" : null;
                  });
                },
              ),
              FilterChip(
                label: Text("Entertainment"),
                selected: selectedEventType == "Entertainment",
                onSelected: (bool selected) {
                  setState(() {
                    selectedEventType = selected ? "Entertainment" : null;
                  });
                },
              ),
              FilterChip(
                label: Text("Trip"),
                selected: selectedEventType == "Trip",
                onSelected: (bool selected) {
                  setState(() {
                    selectedEventType = selected ? "Trip" : null;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(Map<String, String> event, int originalIndex) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEventImage(event['photoUrl']),
            _buildRatingBar(originalIndex),
            _buildEventDetails(event),
            _buildAttendanceButtons(originalIndex),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredEvents = getFilteredEvents();

    return Scaffold(
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: filteredEvents.isEmpty
                ? Center(child: Text("No events available"))
                : ListView.builder(
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                final event = filteredEvents[index];
                final originalIndex = widget.events.indexOf(event);
                return _buildEventCard(event, originalIndex);
              },
            ),
          ),
        ],
      ),
    );
  }
}