import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'banner_ad.dart';

sealed class BannerType {
  final bool isAdaptive;

  BannerType({this.isAdaptive = false});
}

class HomeBanner extends BannerType {}

class StatisticsBanner extends BannerType {}

class RecommendBanner extends BannerType {}

class MoreBanner extends BannerType {}

class SettingBanner extends BannerType {}

class DetailBanner extends BannerType {}

class DetailAdaptiveBanner extends BannerType {

  DetailAdaptiveBanner({super.isAdaptive = true});
}

extension BannerTypeExtension on BannerType {
  String get adUnitId {
    if (kDebugMode) return 'ca-app-pub-3940256099942544/9214589741';

    switch (this) {
      case HomeBanner():
        return Platform.isAndroid
            ? 'ca-app-pub-9816471715610408/8395987389'
            : 'ca-app-pub-9816471715610408/4022129114';
      case StatisticsBanner():
        return Platform.isAndroid
            ? 'ca-app-pub-9816471715610408/1722767822'
            : 'ca-app-pub-9816471715610408/1395965773';
      case RecommendBanner():
        return Platform.isAndroid
            ? 'ca-app-pub-9816471715610408/2970053276'
            : 'ca-app-pub-9816471715610408/5087297764';
      case MoreBanner():
        return Platform.isAndroid
            ? 'ca-app-pub-9816471715610408/1656971602'
            : 'ca-app-pub-9816471715610408/7769802435';
      case SettingBanner():
        return Platform.isAndroid
            ? 'ca-app-pub-9816471715610408/9343889939'
            : 'ca-app-pub-9816471715610408/4590256709';
      case DetailBanner():
        return Platform.isAndroid
            ? 'ca-app-pub-9816471715610408/6608764003'
            : 'ca-app-pub-9816471715610408/9749932664';
      case DetailAdaptiveBanner():
        return Platform.isAndroid
            ? 'ca-app-pub-9816471715610408/9330629259'
            : 'ca-app-pub-9816471715610408/3319754672';
    }
  }

  BannerAd? get bannerAd {
    switch (this) {
      case HomeBanner(): return homeBannerAd;
      case StatisticsBanner(): return statisticsBannerAd;
      case RecommendBanner(): return recommendBannerAd;
      case MoreBanner(): return moreBannerAd;
      case SettingBanner():return settingBannerAd;
      case DetailBanner(): return detailBannerAd;
      case DetailAdaptiveBanner(): return detailAdaptiveBannerAd;
    }
  }
}
