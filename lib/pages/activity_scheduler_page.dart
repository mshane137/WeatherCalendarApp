import 'package:flutter/material.dart';

class ActivitySchedulerPage extends StatefulWidget {
  final int dayIndex;

  const ActivitySchedulerPage({super.key, required this.dayIndex});

  @override
  _ActivitySchedulerPageState createState() => _ActivitySchedulerPageState();
}

class _ActivitySchedulerPageState extends State<ActivitySchedulerPage> {
  // Stores activities for the selected day
  List<Map<String, dynamic>> activities = [];
  List<Map<String, dynamic>> repeatedActivities = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule for Day ${widget.dayIndex}"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: 24,
              itemBuilder: (context, index) {
                final hourLabel = "${index.toString().padLeft(2, '0')}:00";

                return Column(
                  children: [
                    ListTile(
                      title: Text(hourLabel),
                      trailing: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          _openAddActivityDialog(hourLabel);
                        },
                      ),
                    ),
                    // Show any activities saved for this hour
                    ...activities
                        .where((a) => a["time"] == hourLabel)
                        .map((a) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("• ${a["name"]}",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                  if (a["repeat"])
                                    const Text("(Repeats Daily)",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.blueGrey)),
                                ],
                              ),
                            ))
                        .toList(),
                    const Divider(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Opens a modal to add an activity
  void _openAddActivityDialog(String hour) {
    TextEditingController nameController = TextEditingController();
    bool repeatDaily = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text("Add Activity at $hour"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Activity Name",
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Checkbox(
                      value: repeatDaily,
                      onChanged: (value) {
                        setStateDialog(() {
                          repeatDaily = value ?? false;
                        });
                      },
                    ),
                    const Text("Repeat Daily"),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.trim().isEmpty) return;

                  setState(() {
                    activities.add({
                      "time": hour,
                      "name": nameController.text.trim(),
                      "repeat": repeatDaily,
                    });

                    if (repeatDaily) {
                      repeatedActivities.add({
                        "name": nameController.text.trim(),
                        "time": hour,
                      });
                    }
                  });

                  Navigator.pop(context);
                },
                child: const Text("Add"),
              ),
            ],
          );
        });
      },
    );
  }
}
