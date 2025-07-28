import 'package:collection/collection.dart';
import 'package:core/core.dart';
import 'package:designsystem/assets/icons.dart';
import 'package:designsystem/component/ads/banner_ad_widget.dart';
import 'package:designsystem/component/ads/banner_type.dart';
import 'package:designsystem/component/app_bar/lotto_app_bar.dart';
import 'package:designsystem/component/divider/horizontal_divider.dart';
import 'package:designsystem/component/media/svg_icon.dart';
import 'package:designsystem/theme/colors.dart';
import 'package:designsystem/theme/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottoz/ui/notification_setting/provider/notification_setting_notifier.dart';
import 'package:lottoz/ui/notification_setting/provider/notification_setting_state_provider.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationSettingScreen extends ConsumerWidget {
  const NotificationSettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(notificationSettingNotifierProvider.notifier);
    final state = ref.watch(notificationSettingNotifierProvider);

    ref.listen(notificationSettingNotifierProvider, (prev, next) {
      if (prev?.event != next.event) {
        if (next.event is ShowAppSettingInfoDialog) {
          _showAppSettingInfoDialog(context: context, notifier: notifier);
          notifier.clearEvent();
        }
      }
    });

    return Scaffold(
      appBar: LottoAppBar(
        title: '알림 설정',
        topPadding: MediaQuery.of(context).padding.top,
        hasBack: true,
      ),
      body: _notificationSettingBody(context: context, notifier: notifier, state: state),
      bottomNavigationBar: BannerAdWidget(bannerType: SettingBanner()),
    );
  }

  Widget _notificationSettingBody({
    required BuildContext context,
    required NotificationSettingNotifier notifier,
    required NotificationSettingState state,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('로또 당첨 확인 알림', style: bodyM),
              Switch(
                value: state.isCheckOn,
                activeTrackColor: gray700,
                inactiveThumbColor: gray700,
                onChanged: (isChecked) {
                  notifier.toggleCheckNotification(isOn: isChecked);
                },
              ),
            ],
          ),
        ),
        const HorizontalDivider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('로또 구매 알림', style: bodyM),
                    Switch(
                      value: state.isPurchaseOn,
                      activeTrackColor: gray700,
                      inactiveThumbColor: gray700,
                      onChanged: (isChecked) {
                        notifier.togglePurchaseNotification(isOn: isChecked);
                      },
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('구매 알림 시간', style: bodyM),
                        GestureDetector(
                          onTap: () {
                            if (state.isPurchaseOn) {
                              _showPurchaseTimeSettingBottomSheet(context: context, state: state);
                            }
                          },
                          child: Row(
                            children: [
                              Text(
                                '매주 ${state.purchaseTimeDayOfWeek}요일 ${state.purchaseTimeAmPm} '
                                '${state.purchaseTimeHour.padZero()}:${state.purchaseTimeMinute.padZero()}',
                                style: subtitle2,
                              ),
                              const SvgIcon(asset: arrowRightIcon, size: 24),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  state.isPurchaseOn
                      ? const SizedBox()
                      : Container(
                          width: double.infinity,
                          height: 42,
                          color: gray100.withValues(alpha: 0.4),
                        ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  _showPurchaseTimeSettingBottomSheet({
    required BuildContext context,
    required NotificationSettingState state,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16)),
      ),
      builder: (context) {
        return _PurchaseTimeSettingBottomSheet(
          currentDayOfWeek: state.purchaseTimeDayOfWeek,
          currentAmPm: state.purchaseTimeAmPm,
          currentHour: state.purchaseTimeHour,
          currentMinute: state.purchaseTimeMinute,
        );
      },
    );
  }

  _showAppSettingInfoDialog({
    required BuildContext context,
    required NotificationSettingNotifier notifier,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('알림 권한 허용 요청'),
          titleTextStyle: subtitle1,
          content: const Text('알림 기능을 사용하기 위해서 알림 권한이 필요합니다.'),
          contentTextStyle: bodyM,
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: Text('취소', style: subtitle3.copyWith(fontWeight: FontWeight.w700)),
            ),
            TextButton(
              onPressed: () async {
                context.pop();
                final isGranted = await openAppSettings();
                if (isGranted) {
                  notifier.fetchNotificationSetting();
                }
              },
              child: Text(
                '권한 설정',
                style: subtitle3.copyWith(fontWeight: FontWeight.w700, color: graphBlue),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PurchaseTimeSettingBottomSheet extends ConsumerStatefulWidget {
  final String currentDayOfWeek;
  final String currentAmPm;
  final int currentHour;
  final int currentMinute;

  const _PurchaseTimeSettingBottomSheet({
    required this.currentDayOfWeek,
    required this.currentAmPm,
    required this.currentHour,
    required this.currentMinute,
  });

  @override
  ConsumerState<_PurchaseTimeSettingBottomSheet> createState() =>
      _PurchaseTimeSettingBottomSheetState();
}

class _PurchaseTimeSettingBottomSheetState extends ConsumerState<_PurchaseTimeSettingBottomSheet> {
  late NotificationSettingNotifier notifier;
  String _currentDayOfWeek = '금';
  String _currentAmPm = '오후';
  int _currentHour = 9;
  int _currentMinute = 0;

  @override
  void initState() {
    notifier = ref.read(notificationSettingNotifierProvider.notifier);
    _currentDayOfWeek = widget.currentDayOfWeek;
    _currentAmPm = widget.currentAmPm;
    _currentHour = widget.currentHour;
    _currentMinute = widget.currentMinute;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            child: Row(
              children: [
                const SizedBox(width: 120),
                const Expanded(
                  child: Text('구매 알림 시간', style: h4, textAlign: TextAlign.center),
                ),
                Row(
                  children: [
                    Container(padding: const EdgeInsets.symmetric(vertical: 4), width: 60),
                    GestureDetector(
                      onTap: () {
                        notifier.updatePurchaseNotificationTime(
                          dayOfWeek: _currentDayOfWeek,
                          amPm: _currentAmPm,
                          hour: _currentHour,
                          minute: _currentMinute,
                        );
                        context.pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        width: 60,
                        child: Center(
                          child: Text('확인', style: h5.copyWith(color: graphBlue)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['일', '월', '화', '수', '목', '금', '토'].map((dayOfWeek) {
                return _dayOfWeek(dayOfWeek: dayOfWeek, selectedDayOfWeek: _currentDayOfWeek);
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _amPm(),
                    _Picker(
                      initNumber: _currentHour,
                      start: 1,
                      end: 12,
                      itemCount: 5,
                      onChanged: (hour) {
                        setState(() {
                          _currentHour = hour;
                        });
                      },
                    ),
                    _Picker(
                      initNumber: _currentMinute,
                      start: 0,
                      end: 59,
                      itemCount: 5,
                      step: 10,
                      onChanged: (minute) {
                        setState(() {
                          _currentMinute = minute;
                        });
                      },
                    ),
                  ],
                ),
              ),
              _gradient(),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
        ],
      ),
    );
  }

  Widget _dayOfWeek({required String dayOfWeek, required String selectedDayOfWeek}) {
    final isSelected = dayOfWeek == selectedDayOfWeek;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentDayOfWeek = dayOfWeek;
        });
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: isSelected ? 1.5 : 1, color: isSelected ? gray800 : gray100),
        ),
        child: Text(dayOfWeek, style: isSelected ? h5 : subtitle2.copyWith(color: gray100)),
      ),
    );
  }

  Widget _amPm() {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 100) / 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: ['오전', '오후'].mapIndexed((index, amPm) {
          final isSelected = _currentAmPm == amPm;

          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _currentAmPm = amPm;
                  });
                },
                behavior: HitTestBehavior.translucent,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: isSelected ? 1.5 : 1,
                      color: isSelected ? gray800 : gray100,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(amPm, style: h3.copyWith(color: isSelected ? gray800 : gray100)),
                ),
              ),
              SizedBox(height: index == 0 ? 24 : 0),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _gradient() {
    return SizedBox(
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IgnorePointer(
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    white.withValues(alpha: 1),
                    white.withValues(alpha: 0.6),
                    white.withValues(alpha: 0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          IgnorePointer(
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    white.withValues(alpha: 0),
                    white.withValues(alpha: 0.6),
                    white.withValues(alpha: 1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Picker extends StatefulWidget {
  final int initNumber;
  final int start;
  final int end;
  final int itemCount;
  final int step;
  final Function(int) onChanged;

  const _Picker({
    required this.initNumber,
    required this.start,
    required this.end,
    required this.itemCount,
    required this.onChanged,
    this.step = 1,
  });

  @override
  State<_Picker> createState() => _PickerState();
}

class _PickerState extends State<_Picker> {
  int _number = 0;

  @override
  void initState() {
    _number = widget.initNumber;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NumberPicker(
      minValue: widget.start,
      maxValue: widget.end,
      value: _number,
      itemCount: widget.itemCount,
      step: widget.step,
      itemWidth: (MediaQuery.of(context).size.width - 100) / 3,
      textStyle: subtitle1,
      selectedTextStyle: h2,
      haptics: true,
      textMapper: (value) {
        return value.padLeft(2, '0');
      },
      onChanged: (value) {
        setState(() {
          _number = value;
        });
        widget.onChanged(value);
      },
    );
  }
}
