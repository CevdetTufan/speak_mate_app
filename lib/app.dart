import 'package:flutter/material.dart';
import 'screens/speech_screen.dart';

class SpeakMateApp extends StatelessWidget {
  const SpeakMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpeakMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A1628),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00B8D4),
          surface: Color(0xFF0A1628),
        ),
        fontFamily: 'Roboto',
      ),
      home: const SpeechScreen(),
    );
  }
}
