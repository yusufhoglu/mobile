import 'package:flutter/material.dart';

class EditEventPage extends StatefulWidget {
  final List<Map<String, String>> events;
  final Function(String, Map<String, String>) onUpdateEvent;

  EditEventPage({required this.events,  required this.onUpdateEvent});

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Event", style: TextStyle(fontWeight: FontWeight.w600)),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.background,
              Theme.of(context).colorScheme.background.withOpacity(0.8),
            ],
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: widget.events.length,
          itemBuilder: (context, index) {
            final event = widget.events[index];
            return _buildEventCard(context, event, index);
          },
        ),
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, Map<String, String> event, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showEditDialog(context, event, index),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                _buildEventTypeIcon(context, event['eventType']),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event['title'] ?? 'Unnamed Event',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Type: ${event['eventType'] ?? 'Not specified'}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Location: ${event['location'] ?? 'Not specified'}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.edit),
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () => _showEditDialog(context, event, index),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventTypeIcon(BuildContext context, String? eventType) {
    IconData iconData;
    Color backgroundColor;

    switch (eventType) {
      case 'Educational':
        iconData = Icons.school;
        backgroundColor = Colors.blue.withOpacity(0.2);
        break;
      case 'Entertainment':
        iconData = Icons.celebration;
        backgroundColor = Colors.purple.withOpacity(0.2);
        break;
      case 'Trip':
        iconData = Icons.card_travel;
        backgroundColor = Colors.green.withOpacity(0.2);
        break;
      default:
        iconData = Icons.event;
        backgroundColor = Colors.grey.withOpacity(0.2);
    }

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconData,
        color: Theme.of(context).colorScheme.primary,
        size: 24,
      ),
    );
  }

  void _showEditDialog(BuildContext context, Map<String, String> event, int index) {
    String title = event['title'] ?? '';
    String description = event['description'] ?? '';
    String location = event['location'] ?? '';
    String date = event['author'] ?? '';
    String photoUrl = event['photoUrl'] ?? '';
    String eventType = event['eventType'] ?? '';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              constraints: BoxConstraints(maxWidth: 500),
              padding: EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Edit Event",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    _buildEditField(
                      label: "Event Name",
                      value: title,
                      onChanged: (value) => title = value,
                      icon: Icons.event,
                    ),
                    _buildEditField(
                      label: "Description",
                      value: description,
                      onChanged: (value) => description = value,
                      icon: Icons.description,
                      maxLines: 3,
                    ),
                    _buildEditField(
                      label: "Location",
                      value: location,
                      onChanged: (value) => location = value,
                      icon: Icons.location_on,
                    ),
                    _buildEditField(
                      label: "Date",
                      value: date,
                      onChanged: (value) => date = value,
                      icon: Icons.calendar_today,
                    ),
                    _buildEditField(
                      label: "Photo URL",
                      value: photoUrl,
                      onChanged: (value) => photoUrl = value,
                      icon: Icons.photo,
                      hintText: "Enter image URL (optional)",
                    ),
                    SizedBox(height: 16),
                    _buildEventTypeSelector(
                      context,
                      currentValue: eventType,
                      onChanged: (value) => setState(() => eventType = value!),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Cancel"),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () async {
                            final updatedEventData = {
                              'title': title,
                              'description': description,
                              'location': location,
                              'date': date,
                              'photoUrl': photoUrl,
                              'eventType': eventType,
                            };
                            await widget.onUpdateEvent(event['id']!, updatedEventData);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text("Save Changes"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEditField({
    required String label,
    required String value,
    required Function(String) onChanged,
    required IconData icon,
    String? hintText,
    int maxLines = 1,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: TextEditingController(text: value),
        onChanged: onChanged,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
        ),
      ),
    );
  }

  Widget _buildEventTypeSelector(
      BuildContext context, {
        required String currentValue,
        required Function(String?) onChanged,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Event Type",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildEventTypeOption(
                context,
                "Educational Event",
                "Educational",
                Icons.school,
                currentValue,
                onChanged,
              ),
              _buildEventTypeOption(
                context,
                "Entertainment Event",
                "Entertainment",
                Icons.celebration,
                currentValue,
                onChanged,
              ),
              _buildEventTypeOption(
                context,
                "Trip Event",
                "Trip",
                Icons.card_travel,
                currentValue,
                onChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventTypeOption(
      BuildContext context,
      String title,
      String value,
      IconData icon,
      String currentValue,
      Function(String?) onChanged,
      ) {
    final isSelected = currentValue == value;
    return InkWell(
      onTap: () => onChanged(value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: currentValue,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}