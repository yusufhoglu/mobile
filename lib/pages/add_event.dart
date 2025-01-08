import 'package:flutter/material.dart';

class AddEventPage extends StatefulWidget {
  final Function(Map<String, String>) onEventAdded;

  AddEventPage({required this.onEventAdded});

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _photoUrlController = TextEditingController();
  String? eventType;
  String? errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  void _createEvent() {
    final newEvent = {
      "title": _nameController.text,
      "description": _descriptionController.text,
      "location": _locationController.text,
      "date": _dateController.text,
      "photoUrl": _photoUrlController.text,
      "eventType": eventType!,
    };

    widget.onEventAdded(newEvent);
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    String? hintText,
    int maxLines = 1,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildEventTypeSelector() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, top: 16),
            child: Text(
              "Event Type",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          _buildEventTypeOption("Educational Event", "Educational", Icons.school),
          _buildEventTypeOption("Entertainment Event", "Entertainment", Icons.celebration),
          _buildEventTypeOption("Trip Event", "Trip", Icons.card_travel),
        ],
      ),
    );
  }

  Widget _buildEventTypeOption(String title, String value, IconData icon) {
    final isSelected = eventType == value;
    return InkWell(
      onTap: () => setState(() {
        eventType = value;
        errorMessage = null;
      }),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: eventType,
              onChanged: (value) => setState(() {
                eventType = value;
                errorMessage = null;
              }),
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Event", style: TextStyle(fontWeight: FontWeight.w600)),
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
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                label: "Event Name",
                icon: Icons.event,
                controller: _nameController,
              ),
              _buildTextField(
                label: "Description",
                icon: Icons.description,
                controller: _descriptionController,
                maxLines: 3,
              ),
              _buildTextField(
                label: "Location",
                icon: Icons.location_on,
                controller: _locationController,
              ),
              _buildTextField(
                label: "Date",
                icon: Icons.calendar_today,
                controller: _dateController,
              ),
              _buildTextField(
                label: "Photo URL",
                icon: Icons.photo,
                controller: _photoUrlController,
                hintText: "Enter image URL (optional)",
              ),
              _buildEventTypeSelector(),
              if (errorMessage != null)
                Container(
                  padding: EdgeInsets.all(12),
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          errorMessage!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (eventType == null) {
                      setState(() {
                        errorMessage = "Please select an event type.";
                      });
                      return;
                    }
                    _createEvent();
                    // widget.onEventAdded({
                    //   "name": _nameController.text,
                    //   "description": _descriptionController.text,
                    //   "location": _locationController.text,
                    //   "author": _dateController.text,
                    //   "photoUrl": _photoUrlController.text,
                    //   "eventType": eventType!,
                    // });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 3,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 8),
                      Text(
                        "Create Event",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}