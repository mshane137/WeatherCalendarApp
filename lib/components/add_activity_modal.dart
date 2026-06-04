import 'package:flutter/material.dart';
import '../models/activity_item.dart';
import '../services/schedule_service.dart';

class AddActivityModal extends StatefulWidget {
  final int dayIndex;
  final Function(ActivityItem) onAdd;

  const AddActivityModal({super.key, required this.dayIndex, required this.onAdd});

  @override
  _AddActivityModalState createState() => _AddActivityModalState();
}

class _AddActivityModalState extends State<AddActivityModal> {
  TimeOfDay selectedTime = TimeOfDay.now();
  final TextEditingController activityController = TextEditingController();
  bool repeatDaily = false;

  @override
  void dispose() {
    activityController.dispose();
    super.dispose();
  }

  Future<void> pickTime() async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void submit() {
    final text = activityController.text.trim();
    if (text.isEmpty) return;

    final activity = ActivityItem(
      dayIndex: widget.dayIndex,
      time: selectedTime,
      activityType: text,
      repeatDaily: repeatDaily,
    );

    // Save activity to ScheduleService
    ScheduleService().addActivity(activity);

    // Clear input and close modal
    activityController.clear();
    Navigator.of(context).pop();

    // Show confirmation?
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Activity "$text" added${repeatDaily ? ' (daily)' : ''}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Add Activity", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            TextField(
              controller: activityController,
              decoration: const InputDecoration(
                labelText: "Activity",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text("Time: ${selectedTime.format(context)}"),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: pickTime,
                  child: const Text("Pick Time"),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: repeatDaily,
                  onChanged: (val) => setState(() => repeatDaily = val ?? false),
                ),
                const Text("Repeat Daily"),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: submit,
              child: const Text("Add Activity"),
            ),
          ],
        ),
      ),
    );
  }
}
