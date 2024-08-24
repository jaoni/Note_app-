import 'package:flutter/material.dart';
import 'package:flutter_application_7/screens/note_screen.dart';
import 'package:flutter_application_7/screens/notes_screen.dart';

import 'category/note_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes app',
      theme: appTheme,
      routes: {
        NotesScreen.route: (context) => const NotesScreen(),
        NoteScreen.route: (context) => const NoteScreen()
      },
      initialRoute: NotesScreen.route,
    );
  }
}
      