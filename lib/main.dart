import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rebirth/rebirth.dart';
import 'package:who_is_liar/app.dart';
import 'package:who_is_liar/settings/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Di.setup();
  runApp(WidgetRebirth(materialApp: const MyApp()));
}
