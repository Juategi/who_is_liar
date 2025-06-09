import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/rendering.dart';

class RemoteConfigController {
  final remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(seconds: 10),
      minimumFetchInterval: Duration.zero,
    ));
    await remoteConfig.fetchAndActivate();
  }

  bool isInMaintenanceMode() {
    try {
      final isMaintenanceMode = remoteConfig.getBool('down');
      return isMaintenanceMode;
    } catch (e) {
      debugPrint('Error fetching maintenance mode: $e');
      return false;
    }
  }
}
