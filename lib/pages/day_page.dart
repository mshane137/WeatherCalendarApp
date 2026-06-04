import 'package:flutter/material.dart';
import 'activity_scheduler_page.dart';

class DayPage extends StatelessWidget {
  final int dayIndex;

  const DayPage({super.key, required this.dayIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Day $dayIndex Details")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              child: Text("Schedule Activity"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActivitySchedulerPage(dayIndex: dayIndex),
              ),
            );
          },
        ),
      ),
      ),
    );
  }
}
