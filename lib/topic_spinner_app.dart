import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/topic_spinner_screen.dart';

class TopicSpinnerApp extends StatelessWidget {
  const TopicSpinnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    const paper = Color(0xFFF3F0E7);
    const ink = Color(0xFF134E4A);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Off The Cuff',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: ink,
          brightness: Brightness.light,
          surface: paper,
        ),
        scaffoldBackgroundColor: paper,
        textTheme: GoogleFonts.baloo2TextTheme(),
        useMaterial3: true,
      ),
      home: const TopicSpinnerScreen(),
    );
  }
}
