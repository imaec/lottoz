import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

AppOpenAd? _appOpenAd;
bool _isShowingAd = false;

loadAppOpenAd({Function? onAdLoaded}) {
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
        debugPrint(' ## onAppOpenAdLoaded : ${ad.adUnitId}');
      },
      onAdFailedToLoad: (error) {
        debugPrint('  ## 앱 열기 광고 로드 실패: $error');
      },
    ),
  );
}

showAppOpenAdIfAvailable() {
  debugPrint('  ## showAppOpenAdIfAvailable');
  if (_appOpenAd == null || _isShowingAd) return;
  _isShowingAd = true;

  _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
    onAdDismissedFullScreenContent: (ad) {
      ad.dispose();
      _appOpenAd = null;
      _isShowingAd = false;
      loadAppOpenAd();
    },
    onAdFailedToShowFullScreenContent: (ad, error) {
      ad.dispose();
      _appOpenAd = null;
      _isShowingAd = false;
      loadAppOpenAd();
    },
  );
  _appOpenAd!.show();
}
