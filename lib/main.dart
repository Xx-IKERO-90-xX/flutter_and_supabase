import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:gestion_alumnos/provider/cours_provider.dart';
import 'package:provider/provider.dart';
import 'package:gestion_alumnos/provider/student_provider.dart';
import 'package:gestion_alumnos/screens/students_screen.dart';
import 'package:gestion_alumnos/screens/main_menu.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => CoursProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App con BD de Estudiantes',
      home: MainMenu(title: 'IES MARE NOSTRUM'),
    );
  }
}
