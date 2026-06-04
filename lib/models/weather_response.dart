import 'weather_day.dart';

class WeatherResponse {
  final CurrentWeather? currentWeather;
  final HourlyWeather? hourly;
  final List<WeatherDay>? daily;

  WeatherResponse({
    required this.currentWeather,
    required this.hourly,
    required this.daily,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      currentWeather: json["current_weather"] != null
          ? CurrentWeather.fromJson(json["current_weather"])
          : null,

      hourly: json["hourly"] != null
          ? HourlyWeather.fromJson(json["hourly"])
          : null,

      daily: json["daily"] != null
          ? WeatherResponse._parseDaily(json["daily"])
          : [],
    );
  }

  // Convert Open-Meteo's daily arrays into WeatherDay list
  static List<WeatherDay> _parseDaily(Map<String, dynamic> dailyJson) {
    List<String> dates = List<String>.from(dailyJson["time"]);
    List<double> highs = List<double>.from(
        dailyJson["temperature_2m_max"].map((v) => (v as num).toDouble()));
    List<double> lows = List<double>.from(
        dailyJson["temperature_2m_min"].map((v) => (v as num).toDouble()));
    List<int> codes =
        List<int>.from(dailyJson["weathercode"].map((v) => v as int));

    List<WeatherDay> days = [];

    for (int i = 0; i < dates.length; i++) {
      days.add(
        WeatherDay(
          date: DateTime.parse(dates[i]),
          highTemp: highs[i],
          lowTemp: lows[i],
          weatherCode: codes[i],
        ),
      );
    }

    return days;
  }
}


// CURRENT WEATHER

class CurrentWeather {
  final double temperature;
  final double windspeed;
  final int weathercode;

  CurrentWeather({
    required this.temperature,
    required this.windspeed,
    required this.weathercode,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: (json["temperature"] as num).toDouble(),
      windspeed: (json["windspeed"] as num).toDouble(),
      weathercode: json["weathercode"] as int,
    );
  }
}


// HOURLY WEATHER
 
class HourlyWeather {
  final List<String> time;
  final List<double> temperature2m;
  final List<int> weathercode;

  HourlyWeather({
    required this.time,
    required this.temperature2m,
    required this.weathercode,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    return HourlyWeather(
      time: List<String>.from(json["time"]),
      temperature2m: List<double>.from(
          json["temperature_2m"].map((v) => (v as num).toDouble())),
      weathercode: List<int>.from(
          json["weathercode"].map((v) => v as int)),
    );
  }
}
