import 'package:designsystem/component/ads/app_open_ad.dart';
import 'package:designsystem/component/ads/banner_type.dart';
import 'package:designsystem/component/ads/interstitial_ad.dart';
import 'package:designsystem/component/ads/interstitial_type.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

BannerAd? homeBannerAd;
BannerAd? statisticsBannerAd;
BannerAd? recommendBannerAd;
BannerAd? moreBannerAd;
BannerAd? settingBannerAd;
BannerAd? detailBannerAd;
BannerAd? detailAdaptiveBannerAd;

InterstitialAd? detailInterstitialAd;
InterstitialAd? recommendInterstitialAd;
InterstitialAd? backupInterstitialAd;

initAd() {
  loadAppOpenAd(onAdLoaded: () {
    // 앱 오픈 시 광고 노출하고 싶으면 주석 해제
    // showAppOpenAdIfAvailable();
  });
  loadInterstitialAd(interstitialType: DetailInterstitial());
  loadInterstitialAd(interstitialType: RecommendInterstitial());
  loadInterstitialAd(interstitialType: BackupInterstitial());
  homeBannerAd = _getBanner(HomeBanner());
  statisticsBannerAd = _getBanner(StatisticsBanner());
  recommendBannerAd = _getBanner(RecommendBanner());
  moreBannerAd = _getBanner(MoreBanner());
  settingBannerAd = _getBanner(SettingBanner());
  detailBannerAd = _getBanner(DetailBanner());
}

BannerAd _getBanner(BannerType bannerType) {
  return BannerAd(
    adUnitId: bannerType.adUnitId,
    size: bannerType.isAdaptive ? AdSize.mediumRectangle : AdSize.leaderboard,
    request: const AdRequest(),
    listener: BannerAdListener(
      onAdLoaded: (ad) {
        debugPrint(' ## onBannerAdLoaded : ${ad.adUnitId}');
      },
      onAdFailedToLoad: (ad, error) {
        debugPrint(' ## 배너 광고 로드 실패: $error');
        ad.dispose();
      },
    ),
  )..load();
}


