import 'package:flutter/material.dart';
import 'add_event.dart';
import 'edit_event.dart';
import 'delete_event.dart';

class AdminPage extends StatelessWidget {
  final List<Map<String, String>> events;
  final Function(Map<String, String>) onEventAdded;
  final Function(String, Map<String, String>) onUpdateEvent;
  final Function(String) onEventDeleted;

  const AdminPage({
    Key? key,
    required this.events,
    required this.onEventAdded,
    required this.onEventDeleted,
    required this.onUpdateEvent,
  }) : super(key: key);

  Widget _buildAdminAction({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 28,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Admin Panel",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
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
              // Welcome Header
              Text(
                "WELCOME TO THE\nADMIN PANEL",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "The efficient and easy way to manage your events",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 32),

              // Admin Actions
              _buildAdminAction(
                context: context,
                title: "Add Event",
                icon: Icons.add_circle_outline,
                color: Theme.of(context).colorScheme.primary,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEventPage(onEventAdded: onEventAdded),
                  ),
                ),
              ),
              _buildAdminAction(
                context: context,
                title: "Edit Event",
                icon: Icons.edit_outlined,
                color: Theme.of(context).colorScheme.secondary,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditEventPage(
                      events: events,
                      onUpdateEvent: onUpdateEvent,
                    ),
                  ),
                ),
              ),
              _buildAdminAction(
                context: context,
                title: "Delete Event",
                icon: Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeleteEventPage(
                      events: events,
                      onEventDeleted: onEventDeleted,
                    ),
                  ),
                ),
              ),
              _buildAdminAction(
                context: context,
                title: "Events Homepage",
                icon: Icons.home_outlined,
                color: Theme.of(context).colorScheme.tertiary,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}