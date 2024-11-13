import 'package:flutter/material.dart';
import 'package:flutter_counter_cubit/counter/counter.dart';

/// {@template counter_app}
/// A [MaterialApp] which sets the `home` to [CounterPage].
/// {@endtemplate}
class CounterApp extends MaterialApp {
  CounterApp({super.key}) : super(
    home: const CounterPage(),
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
    ),
  );
}
