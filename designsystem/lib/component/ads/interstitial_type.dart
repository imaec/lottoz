import 'dart:io';

import 'package:flutter/foundation.dart';

sealed class InterstitialType {}

class DetailInterstitial extends InterstitialType {}

class RecommendInterstitial extends InterstitialType {}

class BackupInterstitial extends InterstitialType {}

extension InterstitialTypeExtension on InterstitialType {
  String get adUnitId {
    if (kDebugMode) return 'ca-app-pub-3940256099942544/1033173712';

    switch (this) {
      case DetailInterstitial():
        return Platform.isAndroid
            ? 'ca-app-pub-7147836151485354/2899337875'
            : 'ca-app-pub-7147836151485354/8702544492';
      case RecommendInterstitial():
        return Platform.isAndroid
            ? 'ca-app-pub-7147836151485354/2077759533'
            : 'ca-app-pub-7147836151485354/4839654246';
      case BackupInterstitial():
        return Platform.isAndroid
            ? 'ca-app-pub-7147836151485354/5589080394'
            : 'ca-app-pub-7147836151485354/5940982920';
    }
  }
}
