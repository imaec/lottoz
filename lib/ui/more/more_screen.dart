import 'package:designsystem/assets/icons.dart';
import 'package:designsystem/component/ads/banner_ad_widget.dart';
import 'package:designsystem/component/ads/banner_type.dart';
import 'package:designsystem/component/ads/interstitial_ad.dart';
import 'package:designsystem/component/ads/interstitial_type.dart';
import 'package:designsystem/component/app_bar/lotto_app_bar.dart';
import 'package:designsystem/component/divider/horizontal_divider.dart';
import 'package:designsystem/component/media/svg_icon.dart';
import 'package:designsystem/component/picker/lotto_number_picker.dart';
import 'package:designsystem/component/snackbar/snackbar.dart';
import 'package:designsystem/theme/colors.dart';
import 'package:designsystem/theme/fonts.dart';
import 'package:domain/model/setting/backup_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

    ref.listen(moreNotifierProvider, (prev, next) {
      if (prev?.event != next.event) {
        if (next.event is ShowSnackBar) {
          showSnackBar(context: context, message: (next.event as ShowSnackBar).message);
          notifier.clearEvent();
        }
      }
    });

    return Scaffold(
      appBar: const LottoAppBar(title: '더보기'),
      body: Column(
        children: [
          Expanded(
            child: _moreBody(notifier: notifier, state: state),
          ),
          BannerAdWidget(bannerType: MoreBanner()),
        ],
      ),
    );
  }

  Widget _moreBody({required MoreNotifier notifier, required MoreState state}) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              _myNumbers(notifier: notifier),
              const HorizontalDivider(),
              _appSettings(notifier: notifier, state: state),
              const HorizontalDivider(),
              _appInfos(),
            ],
          ),
        ),
        if (state.isLoading)
          Container(
            color: gray900.withValues(alpha: 0.4),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Widget _myNumbers({required MoreNotifier notifier}) {
    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('내 번호', style: h4),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  appRouter.push('/myNumber');
                },
                behavior: HitTestBehavior.translucent,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('내 번호 확인하기', style: bodyM),
                      SvgIcon(asset: arrowRightIcon, size: 24),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showBackupBottomSheet(
                    context: context,
                    notifier: notifier,
                    title: '번호 내보내기',
                    isBackup: true,
                  );
                },
                behavior: HitTestBehavior.translucent,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('내보내기', style: bodyM),
                      SvgIcon(asset: arrowRightIcon, size: 24),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showBackupBottomSheet(
                    context: context,
                    notifier: notifier,
                    title: '번호 가져오기',
                    isBackup: false,
                  );
                },
                behavior: HitTestBehavior.translucent,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('가져오기', style: bodyM),
                      SvgIcon(asset: arrowRightIcon, size: 24),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  appRouter.push('/qrScanner');
                },
                behavior: HitTestBehavior.translucent,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('QR 코드로 당첨 확인하기', style: bodyM),
                      SvgIcon(asset: arrowRightIcon, size: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _appSettings({required MoreNotifier notifier, required MoreState state}) {
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
              GestureDetector(
                onTap: () {
                  appRouter.push('/notificationSetting');
                },
                behavior: HitTestBehavior.translucent,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('알림 설정', style: bodyM),
                      SvgIcon(asset: arrowRightIcon, size: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
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

                    return Text(info != null ? info.version : '', style: subtitle2);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _showBackupBottomSheet({
    required BuildContext context,
    required MoreNotifier notifier,
    required String title,
    required bool isBackup,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(title, style: h4, textAlign: TextAlign.center),
              ),
              const HorizontalDivider(),
              Column(
                children: [
                  // todo : iCloud 백업/복원 구현
                  // Platform.isIOS
                  //     ? Column(
                  //         children: [
                  //           GestureDetector(
                  //             onTap: () {
                  //               if (isBackup) {
                  //                 notifier.backupMyNumbers(backupType: BackupType.iCloud);
                  //               } else {
                  //                 notifier.restoreFileFrom(backupType: BackupType.iCloud);
                  //               }
                  //               context.pop();
                  //             },
                  //             behavior: HitTestBehavior.translucent,
                  //             child: Padding(
                  //               padding: const EdgeInsets.symmetric(vertical: 24),
                  //               child: Text(
                  //                 'iCloud${isBackup ? '로 내보내기' : '에서 가져오기'}',
                  //                 style: subtitle2.copyWith(color: gray700),
                  //               ),
                  //             ),
                  //           ),
                  //           const HorizontalDivider(),
                  //         ],
                  //       )
                  //     : const SizedBox(),
                  GestureDetector(
                    onTap: () async {
                      context.pop();
                      bool result;
                      if (isBackup) {
                        result = await notifier.backupMyNumbers(backupType: BackupType.googleDrive);
                      } else {
                        result = await notifier.restoreMyNumbers(
                          backupType: BackupType.googleDrive,
                        );
                      }
                      if (result) {
                        await Future.delayed(const Duration(milliseconds: 500));
                        BackupInterstitial().showInterstitialAd();
                      }
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'Google Drive${isBackup ? '로 내보내기' : '에서 가져오기'}',
                        style: subtitle2.copyWith(color: gray700),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
