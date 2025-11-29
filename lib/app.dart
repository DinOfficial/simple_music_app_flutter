import 'package:flutter/material.dart';
import 'package:simple_music_app_flutter/ui/home_screen.dart';

class SimpleMusicApp extends StatefulWidget {
  const SimpleMusicApp({super.key});

  @override
  State<SimpleMusicApp> createState() => _SimpleMusicAppState();
}

class _SimpleMusicAppState extends State<SimpleMusicApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
