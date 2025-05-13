import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/note_list_screen.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Catatan',
      theme: context.watch<ThemeProvider>().currentTheme,
      home: const NoteListScreen(),
    );
  }
}
