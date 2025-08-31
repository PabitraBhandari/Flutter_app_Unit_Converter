import 'package:flutter/material.dart';
import 'unit_converter_gui.dart';

void main() {
  runApp(const UnitConverterApp());
}

/// Root of the application. Uses Material 3 and a dark theme to complement the GUI.
class UnitConverterApp extends StatelessWidget {
  const UnitConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit Converter',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF22D3EE),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0B0F1B),
      ),
      home: const Scaffold(body: UnitConverterGUI()),
      debugShowCheckedModeBanner: false,
    );
  }
}
