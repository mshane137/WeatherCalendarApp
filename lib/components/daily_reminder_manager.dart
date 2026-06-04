import 'package:flutter/material.dart';
import '../models/activity_item.dart';

class DailyReminderManager extends StatelessWidget {
  final List<ActivityItem> dailyActivities;
  final Function(ActivityItem)? onToggle;

  const DailyReminderManager({
    super.key,
    required this.dailyActivities,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (dailyActivities.isEmpty) {
      return const Center(child: Text("No daily reminders set."));
    }

    return ListView.builder(
      itemCount: dailyActivities.length,
      itemBuilder: (context, index) {
        final activity = dailyActivities[index];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(activity.activityType),
            subtitle: Text(
              "${activity.time.format(context)} (Daily)",
            ),
            trailing: Switch(
              value: true,
              onChanged: (val) {
                if (onToggle != null) onToggle!(activity);
              },
            ),
          ),
        );
      },
    );
  }
}
