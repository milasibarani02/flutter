import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_post_list/post_list/post_list.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Post List",
      theme: ThemeData(
        // Customize the colors to pastel pink tones
        primaryColor: Color(0xFFF8C9D7), // Soft pastel pink
        secondaryHeaderColor: Color(0xFFF1A7C1), // Slightly darker pink
        scaffoldBackgroundColor: Color(0xFFFCE4EC), // Light pink background
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFF8C9D7), // Match the app bar to the primary color
        ),
        // Updated text theme to use the new naming convention
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black87), // For general body text
          bodyMedium: TextStyle(color: Colors.black87), // For medium body text
          bodySmall: TextStyle(color: Colors.black87), // For smaller body text
          headlineMedium: TextStyle(color: Colors.black87), // For app bar title and headings
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFFF8C9D7), // Light pink seed color
          primary: Color(0xFFF8C9D7),
          secondary: Color(0xFFF1A7C1),
        ),
      ),
      // Enable scroll behavior by other devices on web
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      home: const PostListPage(),
    );
  }
}
