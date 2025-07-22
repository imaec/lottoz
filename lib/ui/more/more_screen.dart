import 'package:designsystem/assets/icons.dart';
import 'package:designsystem/component/app_bar/lotto_app_bar.dart';
import 'package:designsystem/component/divider/horizontal_divider.dart';
import 'package:designsystem/component/media/svg_icon.dart';
import 'package:designsystem/component/picker/lotto_number_picker.dart';
import 'package:designsystem/theme/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottoz/router/go_router.dart';
import 'package:lottoz/ui/more/provider/more_notifier.dart';
import 'package:lottoz/ui/more/provider/more_state_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(moreNotifierProvider.notifier);
    final state = ref.watch(moreNotifierProvider);

    return Scaffold(
      appBar: const LottoAppBar(title: '더보기'),
      body: _moreBody(notifier: notifier, state: state),
    );
  }

  Widget _moreBody({required MoreNotifier notifier, required MoreState state}) {
    return Column(
      children: [
        _myNumbers(),
        const HorizontalDivider(),
        _appSettings(notifier: notifier, state: state),
        const HorizontalDivider(),
        _appInfos(),
      ],
    );
  }

  Widget _myNumbers() {
    // todo : QR 코드로 당첨 확인하기
    return GestureDetector(
      onTap: () {
        appRouter.push('/myNumber');
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

  Widget _appSettings({required MoreNotifier notifier, required MoreState state}) {
    // todo : 알림 설정 추가
    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('앱 설정', style: h4),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  showNumberPicker(
                    context: context,
                    title: '회차 설정',
                    start: 10,
                    end: state.maxRound,
                    step: 10,
                    initNumber: state.statisticsSize,
                    isAllShow: true,
                    onSelected: (number) {
                      notifier.updateStatisticsSize(statisticsSize: number);
                    },
                  );
                },
                behavior: HitTestBehavior.translucent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('통계 회차 설정', style: bodyM),
                      Text('${state.statisticsSize}회', style: subtitle2),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('내 번호 내보내기', style: bodyM),
                    SvgIcon(asset: arrowRightIcon, size: 24),
                  ],
                ),
              ),
              const Padding(
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
    );
  }

  Widget _appInfos() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('앱 정보', style: h4),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('앱 버전', style: bodyM),
                FutureBuilder(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    final info = snapshot.data;

                    return Text(
                      info != null ? info.version : '',
                      style: subtitle2
                    );
                  }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
