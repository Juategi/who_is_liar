import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:who_is_liar/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
