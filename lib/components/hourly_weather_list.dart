import 'package:flutter/material.dart';
import '../models/weather_hour.dart';
import '../utils/weather_code_helper.dart';
import '../models/weather_day.dart';

class HourlyWeatherList extends StatelessWidget {
  final List<WeatherHour> hours;
  final WeatherDay? day;

  const HourlyWeatherList({super.key, required this.hours, this.day});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 120, // fixed height for horizontal scroll
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hours.length,
        itemBuilder: (context, index) {
          final hourData = hours[index];
          final dateTime = hourData.time;

          // Format hour (e.g., 14:00 → 2 PM)
          final hourString =
              "${dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12} ${dateTime.hour >= 12 ? 'PM' : 'AM'}";

          // Convert temperature C° → F°
          double tempF = (hourData.temperature * 9 / 5) + 32;

          // Weather description
          final description = weatherCodeToDescription(hourData.weatherCode);

          return Container(
            width: 100,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.cardColor, // use theme color
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: theme.brightness == Brightness.light
                      ? Colors.grey.withOpacity(0.3)
                      : Colors.black.withOpacity(0.5),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(hourString,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text("${tempF.toStringAsFixed(0)}°F",
                    style: theme.textTheme.bodySmall),
                const SizedBox(height: 4),
                Text(description,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall),
              ],
            ),
          );
        },
      ),
    );
  }
}
