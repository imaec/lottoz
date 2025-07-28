import 'package:designsystem/component/ads/banner_type.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatelessWidget {
  final BannerType bannerType;

  const BannerAdWidget({super.key, required this.bannerType});

  @override
  Widget build(BuildContext context) {
    if (bannerType.bannerAd == null) return const SizedBox(height: 50);

    final height = bannerType.bannerAd!.size.height.toDouble();
    return Container(
      alignment: Alignment.center,
      width: bannerType.bannerAd!.size.width.toDouble(),
      height: height > 0 ? height : (bannerType.isAdaptive ? 300 : 90),
      child: AdWidget(ad: bannerType.bannerAd!),
    );
  }
}
