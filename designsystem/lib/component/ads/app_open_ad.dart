import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

AppOpenAd? _appOpenAd;
bool _isShowingAd = false;
bool _suppressAppOpenAd = false;
DateTime? _lastAdShownTime;

loadAppOpenAd({Function? onAdLoaded}) {
  final adUnitId = kDebugMode
      ? 'ca-app-pub-3940256099942544/9257395921'
      : (Platform.isAndroid
      ? 'ca-app-pub-7147836151485354/4787350214'
      : 'ca-app-pub-7147836151485354/8215243734');
  AppOpenAd.load(
    adUnitId: adUnitId,
    request: const AdRequest(),
    adLoadCallback: AppOpenAdLoadCallback(
      onAdLoaded: (ad) {
        _appOpenAd = ad;
        onAdLoaded?.call();
      },
      onAdFailedToLoad: (error) {
        debugPrint('  [ERROR] 앱 열기 광고 로드 실패($adUnitId)\n\t\t$error');
      },
    ),
  );
}

suppressAppOpenAdTemporarily() {
  _suppressAppOpenAd = true;
  Future.delayed(const Duration(seconds: 2), () {
    _suppressAppOpenAd = false;
  });
}

showAppOpenAdIfAvailable() {
  // 30초 이내 재표시 방지
  if (_lastAdShownTime != null &&
      DateTime.now().difference(_lastAdShownTime!) < const Duration(seconds: 30)) {
    return;
  }

  if (_appOpenAd == null || _isShowingAd || _suppressAppOpenAd) return;
  _isShowingAd = true;
  _lastAdShownTime = DateTime.now();

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
