import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdController {
  InterstitialAd? _interstitialAd;

  Future<void> loadAd() async {
    final bool isDev = const String.fromEnvironment('ENV') == 'dev';
    final adUnitId = isDev
        ? Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/1033173712'
            : 'ca-app-pub-3940256099942544/4411468910'
        : 'ca-app-pub-8550647653356634/3500722699';
    await InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          // Keep a reference to the ad so you can show it later.
          _interstitialAd = ad;
          _checkAndShowAd();
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  void _checkAndShowAd() {
    if (_interstitialAd == null) {
      debugPrint('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.show();
    _interstitialAd = null;
  }
}
