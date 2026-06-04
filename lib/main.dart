import 'package:flutter/material.dart';
import 'pages/timeline_page.dart';

void main() {
  runApp(const WeatherActivityApp());
}

class WeatherActivityApp extends StatefulWidget {
  const WeatherActivityApp({super.key});

  @override
  _WeatherActivityAppState createState() => _WeatherActivityAppState();
}

class _WeatherActivityAppState extends State<WeatherActivityApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather Calendar',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Colors.black,
        cardColor: Colors.grey[900],
      ),
      themeMode: _themeMode,
      home: TimelinePage(
        toggleTheme: toggleTheme, // pass toggle function to TimelinePage
      ),
    );
  }
}
