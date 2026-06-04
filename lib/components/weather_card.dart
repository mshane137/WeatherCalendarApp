import 'package:flutter/material.dart';
import '../models/weather_day.dart';


class WeatherCard extends StatelessWidget {
  final WeatherDay day;

  const WeatherCard({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    // Convert C° to F°
    double maxF = (day.highTemp * 9 / 5) + 32;
    double minF = (day.lowTemp * 9 / 5) + 32;

    // Get weather description from code
    final description = "icon not ready";

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side: date & description
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${day.date.month}/${day.date.day}  (${_weekdayName(day.date.weekday)})",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(description, style: const TextStyle(fontSize: 16)),
              ],
            ),

            // Right side: temperatures
            Column(
              children: [
                Text("${maxF.toStringAsFixed(0)}°F",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600)),
                Text("${minF.toStringAsFixed(0)}°F",
                    style: const TextStyle(
                        fontSize: 15, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _weekdayName(int weekday) {
    const names = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return names[weekday - 1];
  }
}
