import 'package:designsystem/assets/icons.dart';
import 'package:designsystem/component/app_bar/lotto_app_bar.dart';
import 'package:designsystem/component/divider/horizontal_divider.dart';
import 'package:designsystem/component/media/svg_icon.dart';
import 'package:designsystem/theme/fonts.dart';
import 'package:flutter/material.dart';
import 'package:lottoz/router/go_router.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LottoAppBar(title: '더보기'),
      body: _moreBody(),
    );
  }

  Widget _moreBody() {
    return Column(
      children: [
        _myNumbers(),
        const HorizontalDivider(),
        _appSettings(),
        const HorizontalDivider(),
        _appInfos(),
      ],
    );
  }

  Widget _myNumbers() {
    return GestureDetector(
      onTap: () {
        appRouter.push('/my_number');
      },
      behavior: HitTestBehavior.translucent,
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('내 번호', style: h4),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('내 번호 확인하기', style: bodyM),
                  SvgIcon(asset: arrowRightIcon, size: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appSettings() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('앱 설정', style: h4),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('통계 회차 설정', style: bodyM),
                Text('20회', style: subtitle2),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('내 번호 내보내기', style: bodyM),
                SvgIcon(asset: arrowRightIcon, size: 24),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('내 번호 가져오기', style: bodyM),
                SvgIcon(asset: arrowRightIcon, size: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _appInfos() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('앱 정보', style: h4),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('앱 버전', style: bodyM),
                Text('1.0.0', style: subtitle2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
