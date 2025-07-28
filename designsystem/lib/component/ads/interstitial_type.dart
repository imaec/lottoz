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
            ? 'ca-app-pub-9816471715610408/7905032798'
            : 'ca-app-pub-9816471715610408/6526154909';
      case RecommendInterstitial():
        return Platform.isAndroid
            ? 'ca-app-pub-9816471715610408/6125047263'
            : 'ca-app-pub-9816471715610408/3277175030';
      case BackupInterstitial():
        return Platform.isAndroid
            ? 'ca-app-pub-9816471715610408/9026542772'
            : 'ca-app-pub-9816471715610408/4963174685';
    }
  }
}
