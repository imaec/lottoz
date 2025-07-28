import 'package:designsystem/component/ads/interstitial_type.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

InterstitialAd? _interstitialAd;

loadInterstitialAd(Function? onAdLoaded, {required InterstitialType interstitialType}) {
  InterstitialAd.load(
    adUnitId: interstitialType.adUnitId,
    request: const AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (ad) {
        _interstitialAd = ad;
        onAdLoaded?.call();
      },
      onAdFailedToLoad: (error) => debugPrint('  ## 전면 광고 로드 실패 : $error'),
    ),
  );
}

showInterstitialAd() {
  if (_interstitialAd == null) return;

  _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
    onAdDismissedFullScreenContent: (ad) {
      ad.dispose();
      _interstitialAd = null;
    },
    onAdFailedToShowFullScreenContent: (ad, error) {
      ad.dispose();
      _interstitialAd = null;
    },
  );
  _interstitialAd!.show();
  _interstitialAd = null;
}
