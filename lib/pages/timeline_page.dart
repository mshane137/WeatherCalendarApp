import 'package:flutter/material.dart';
import '../services/weather_api_service.dart';
import '../models/weather_response.dart';
import '../utils/weather_code_helper.dart';
import '../components/hourly_weather_list.dart';
import '../models/weather_hour.dart';
import '../services/schedule_service.dart';
import '../components/add_activity_modal.dart';

class TimelinePage extends StatefulWidget {
  final VoidCallback? toggleTheme;

  const TimelinePage({super.key, this.toggleTheme});

  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  final WeatherApiService api = WeatherApiService();
  WeatherResponse? weather;
  bool isLoading = true;
  int? selectedDayIndex;

  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  Future<void> loadWeather() async {
    const double lat = 29.42;
    const double lon = -98.49;

    WeatherResponse? result = await api.getWeather(lat, lon);

    setState(() {
      weather = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("7-Day Weather Timeline"),
        actions: [
          if (widget.toggleTheme != null)
            IconButton(
              icon: const Icon(Icons.dark_mode),
              onPressed: widget.toggleTheme,
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : weather == null
              ? Center(child: Text("Failed to load weather.", style: theme.textTheme.bodyMedium))
              : buildTimeline(theme),
    );
  }

  Widget buildTimeline(ThemeData theme) {
    final daily = weather!.daily;
    if (daily == null || daily.isEmpty) return Center(child: Text("No daily data", style: theme.textTheme.bodyMedium));

    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = constraints.maxWidth / 4;
        cardWidth = cardWidth.clamp(140, 200);

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(daily.length, (index) {
              final day = daily[index];
              final description = weatherCodeToDescription(day.weatherCode);
              final maxF = (day.highTemp * 9 / 5) + 32;
              final minF = (day.lowTemp * 9 / 5) + 32;
              final isSelected = selectedDayIndex == index;

              return Column(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => selectedDayIndex = isSelected ? null : index),
                    child: SizedBox(
                      width: cardWidth,
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                        margin: const EdgeInsets.all(8),
                        color: theme.cardColor,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${day.date.month}/${day.date.day} (${_weekdayName(day.date.weekday)})",
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Text(description, style: theme.textTheme.bodyMedium),
                              const SizedBox(height: 12),
                              Text("${maxF.toStringAsFixed(0)}°F",
                                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                              Text("${minF.toStringAsFixed(0)}°F",
                                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onBackground.withOpacity(0.6))),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (isSelected)
                    Container(
                      width: cardWidth,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.brightness == Brightness.light
                            ? Colors.grey[100]
                            : Colors.grey[850],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Hourly Forecast
                          if (weather!.hourly != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Hourly Forecast", style: theme.textTheme.titleMedium),
                                SizedBox(height: constraints.maxHeight * 0.01),
                                HourlyWeatherList(
                                  hours: List.generate(weather!.hourly!.time.length, (i) {
                                    return WeatherHour(
                                      time: DateTime.parse(weather!.hourly!.time[i]),
                                      temperature: weather!.hourly!.temperature2m[i],
                                      weatherCode: weather!.hourly!.weathercode[i],
                                    );
                                  }).where((h) => h.time.day == day.date.day).toList(),
                                ),
                                SizedBox(height: constraints.maxHeight * 0.01),
                              ],
                            ),

                          // Activities
                          Text("Activities", style: theme.textTheme.titleMedium),
                          SizedBox(height: constraints.maxHeight * 0.005),
                          ...ScheduleService().getActivitiesForDay(index).map((activity) {
                            return ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(Icons.check_circle_outline, color: theme.iconTheme.color),
                              title: Text(activity.activityType, style: theme.textTheme.bodyMedium),
                              subtitle: Text("${activity.time.format(context)}${activity.repeatDaily ? " (Daily)" : ""}",
                                  style: theme.textTheme.bodySmall),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: theme.iconTheme.color),
                                onPressed: () {
                                  setState(() {
                                    ScheduleService().removeActivity(activity);
                                  });
                                },
                              ),
                            );
                          }).toList(),
                          SizedBox(height: constraints.maxHeight * 0.01),
                          ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (_) => AddActivityModal(
                                  dayIndex: index,
                                  onAdd: (activity) {
                                    ScheduleService().addActivity(activity);
                                    setState(() {});
                                  },
                                ),
                              );
                            },
                            child: const Text("Add Activity"),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            }),
          ),
        );
      },
    );
  }

  String _weekdayName(int weekday) {
    const names = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return names[weekday - 1];
  }
}
