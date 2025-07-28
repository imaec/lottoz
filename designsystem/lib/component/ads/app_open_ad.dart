import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

AppOpenAd? _appOpenAd;

loadAppOpenAd(Function? onAdLoaded) {
  AppOpenAd.load(
    adUnitId: kDebugMode
        ? 'ca-app-pub-3940256099942544/9257395921'
        : (Platform.isAndroid
              ? 'ca-app-pub-9816471715610408/5645700962'
              : 'ca-app-pub-9816471715610408/1465399912'),
    request: const AdRequest(),
    adLoadCallback: AppOpenAdLoadCallback(
      onAdLoaded: (ad) {
        _appOpenAd = ad;
        onAdLoaded?.call();
      },
      onAdFailedToLoad: (error) {
        debugPrint('  ## 앱 열기 광고 로드 실패: $error');
      },
    ),
  );
}

showAppOpenAdIfAvailable() {
  if (_appOpenAd != null) {
    _appOpenAd!.show();
    _appOpenAd = null;
  }
}
