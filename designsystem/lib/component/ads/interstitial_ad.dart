import 'package:designsystem/component/ads/ad.dart';
import 'package:designsystem/component/ads/app_open_ad.dart';
import 'package:designsystem/component/ads/interstitial_type.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

int _detailCount = -1;
int _recommendCount = -1;
int _backupCount = -1;

loadInterstitialAd({required InterstitialType interstitialType}) {
  InterstitialAd.load(
    adUnitId: interstitialType.adUnitId,
    request: const AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (ad) {
        switch (interstitialType) {
          case DetailInterstitial():
            detailInterstitialAd = ad;
          case RecommendInterstitial():
            recommendInterstitialAd = ad;
          case BackupInterstitial():
            backupInterstitialAd = ad;
        }
      },
      onAdFailedToLoad: (error) {
        debugPrint('  [ERROR] 전면 광고 로드 실패(${interstitialType.adUnitId})\n\t\t$error');
      },
    ),
  );
}

extension InterstitialTypeExtension on InterstitialType {
  showInterstitialAd() {
    isAppOpenAddEnable = false;
    final interstitialAd = this.interstitialAd;
    count++;
    if (interstitialAd == null || count % 3 != 0) return;

    interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdWillDismissFullScreenContent: (ad) async {
        suppressAppOpenAdTemporarily();
        await Future.delayed(const Duration(milliseconds: 1000));
        isAppOpenAddEnable = true;
      },
      onAdDismissedFullScreenContent: (ad) async {
        suppressAppOpenAdTemporarily();
        ad.dispose();
        _resetInterstitialAd();
        loadInterstitialAd(interstitialType: this);
        await Future.delayed(const Duration(milliseconds: 1000));
        isAppOpenAddEnable = true;
      },
      onAdFailedToShowFullScreenContent: (ad, error) async {
        ad.dispose();
        _resetInterstitialAd();
        loadInterstitialAd(interstitialType: this);
        await Future.delayed(const Duration(milliseconds: 1000));
        isAppOpenAddEnable = true;
      },
    );
    interstitialAd.show();
    _resetInterstitialAd();
  }

  InterstitialAd? get interstitialAd {
    switch (this) {
      case DetailInterstitial():
        return detailInterstitialAd!;
      case RecommendInterstitial():
        return recommendInterstitialAd!;
      case BackupInterstitial():
        return backupInterstitialAd!;
    }
  }

  int get count {
    switch (this) {
      case DetailInterstitial():
        return _detailCount;
      case RecommendInterstitial():
        return _recommendCount;
      case BackupInterstitial():
        return _backupCount;
    }
  }

  set count(int count) {
    switch (this) {
      case DetailInterstitial():
        _detailCount = count++;
      case RecommendInterstitial():
        _recommendCount = count++;
      case BackupInterstitial():
        _backupCount = 0;
    }
  }

  _resetInterstitialAd() {
    switch (this) {
      case DetailInterstitial():
        detailInterstitialAd = null;
      case RecommendInterstitial():
        recommendInterstitialAd = null;
      case BackupInterstitial():
        backupInterstitialAd = null;
    }
  }
}
