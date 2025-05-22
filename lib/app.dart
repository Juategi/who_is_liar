import 'package:flutter/material.dart';
import 'package:who_is_liar/settings/routes/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Who is Liar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: AppRoutes.getRoutes(),
    );
  }
}
