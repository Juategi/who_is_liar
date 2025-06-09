import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:who_is_liar/controller/game_room/game_room_controller.dart';
import 'package:who_is_liar/controller/remote_config_controller.dart';

import 'package:who_is_liar/settings/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameRoomController>(
      create: (_) => GetIt.instance<GameRoomController>(),
      child: MaterialApp(
        title: 'Catch the Impostor!',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
        ],
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute:
            GetIt.instance<RemoteConfigController>().isInMaintenanceMode()
                ? '/down'
                : '/',
        routes: AppRoutes.getRoutes(),
      ),
    );
  }
}
