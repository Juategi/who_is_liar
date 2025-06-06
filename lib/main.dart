import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rebirth/rebirth.dart';
import 'package:who_is_liar/app.dart';
import 'package:who_is_liar/settings/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await Di.setup();
  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en'),
        Locale('de'),
        Locale('fr'),
        Locale('es')
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: WidgetRebirth(
        materialApp: const MyApp(),
      ),
    ),
  );
}
