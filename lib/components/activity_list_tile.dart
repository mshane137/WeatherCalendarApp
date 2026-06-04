import 'package:flutter/material.dart';
import '../models/activity_item.dart';

class ActivityListTile extends StatelessWidget {
  final ActivityItem activity;
  final VoidCallback? onDelete;

  const ActivityListTile({
    super.key,
    required this.activity,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Format the time nicer
    final hourString =
        "${activity.time.hour % 12 == 0 ? 12 : activity.time.hour % 12}:${activity.time.minute.toString().padLeft(2, '0')} ${activity.time.hour >= 12 ? 'PM' : 'AM'}";

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ListTile(
        leading: const Icon(Icons.access_time),
        title: Text(activity.activityType,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("$hourString${activity.repeatDaily ? ' (Daily)' : ''}"),
        trailing: onDelete != null
            ? IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              )
            : null,
      ),
    );
  }
}
