import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad.dart';

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
            ? 'ca-app-pub-7147836151485354/7058074734'
            : 'ca-app-pub-7147836151485354/6292003573';
      case StatisticsBanner():
        return Platform.isAndroid
            ? 'ca-app-pub-7147836151485354/1478660593'
            : 'ca-app-pub-7147836151485354/2352758564';
      case RecommendBanner():
        return Platform.isAndroid
            ? 'ca-app-pub-7147836151485354/9165578922'
            : 'ca-app-pub-7147836151485354/1841407072';
      case MoreBanner():
        return Platform.isAndroid
            ? 'ca-app-pub-7147836151485354/2962917052'
            : 'ca-app-pub-7147836151485354/9528325401';
      case SettingBanner():
        return Platform.isAndroid
            ? 'ca-app-pub-7147836151485354/5226333913'
            : 'ca-app-pub-7147836151485354/2380463128';
      case DetailBanner():
        return Platform.isAndroid
            ? 'ca-app-pub-7147836151485354/3913252249'
            : 'ca-app-pub-7147836151485354/1067381455';
      case DetailAdaptiveBanner():
        return Platform.isAndroid
            ? 'ca-app-pub-7147836151485354/1227379153'
            : 'ca-app-pub-7147836151485354/2328707839';
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
