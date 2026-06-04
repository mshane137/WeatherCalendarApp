import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_response.dart';
import '../models/weather_day.dart';


class WeatherApiService {
  // Fetch 7-day forecast and hourly for a given location
  Future<WeatherResponse?> getWeather(double lat, double lon) async {
    try {
      final url = Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&hourly=temperature_2m,weathercode&daily=temperature_2m_max,temperature_2m_min,weathercode&current_weather=true&timezone=auto');
      
      final response = await http.get(url);

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      
      // Parse current weather
      final currentWeather = data['current_weather'] != null
          ? CurrentWeather.fromJson(data['current_weather'])
          : null;

      // Parse hourly weather
      HourlyWeather? hourly;
      if (data['hourly'] != null) {
        hourly = HourlyWeather.fromJson(data['hourly']);
      }

      // Parse daily weather
      List<WeatherDay>? daily;
      if (data['daily'] != null) {
        final times = List<String>.from(data['daily']['time']);
        final maxTemps = List<double>.from(
            data['daily']['temperature_2m_max'].map((v) => (v as num).toDouble()));
        final minTemps = List<double>.from(
            data['daily']['temperature_2m_min'].map((v) => (v as num).toDouble()));
        final codes = List<int>.from(data['daily']['weathercode']);

        daily = List.generate(times.length, (i) {
          return WeatherDay(
            date: DateTime.parse(times[i]),
            highTemp: maxTemps[i],
            lowTemp: minTemps[i],
            weatherCode: codes[i],
          );
        });
      }

      return WeatherResponse(
        currentWeather: currentWeather,
        hourly: hourly,
        daily: daily,
      );
    } catch (e) {
      print("Error fetching weather: $e");
      return null;
    }
  }
}
